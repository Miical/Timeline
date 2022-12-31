//
//  TimelineView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var timeline: Timeline
    @State var completedTaskEditor = false
    @State var plannedTaskToExecute: PlannedTask?
    
    var body: some View {
        VStack {
            titleBar
            Spacer(minLength: 0)
            timelineBody
        }
    }
    
    var titleBar: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }.padding(.leading, 15.0)
            
            Spacer(minLength: 0)
            
            Label("Timeline", systemImage: "calendar.day.timeline.leading")
                .font(.custom("AvenirNextCondensed-DemiBold", size: 18))
            
            Spacer(minLength: 0)
            
            Button(action: {
                
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }.padding(.trailing, 15.0)
        }
        .padding()
        .background { Color.white }
    }
    
    var timelineBody: some View {
        VStack {
            ScrollView {
                ForEach(timeline.allRecords(for: Date())) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        CompletedTaskCard(completedTask: completedTask)
                            .timelineCardify(
                                color: timeline.taskCategory(id: completedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
                    case .plannedTask(let plannedTask):
                        PlannedTaskCard(plannedTask: plannedTask)
                            .timelineCardify(
                                color: timeline.taskCategory(id: plannedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
                    case .todoTask(let todoTask):
                        TodoTaskCard(todoTask: todoTask)
                            .timelineCardify(
                                color: .yellow,
                                time: record.getBeginTime()!)
                    }
                }
            }
        }
    }
}

struct TimelineCardify: ViewModifier {
    var themeColor: Color
    var time: Date
    
    func body(content: Content) -> some View {
        ZStack {
            HStack {
                Rectangle()
                    .foregroundColor(themeColor)
                    .frame(width: CardConstants.lineWidth)
                    .opacity(0.1)
                    .offset(x: CardConstants.lineXOffset)
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                        Circle()
                            .stroke(lineWidth: 0.05)
                            .foregroundColor(themeColor)
                        Circle()
                            .foregroundColor(themeColor)
                            .frame(width: CardConstants.circleSize)
                            .opacity(0.7)
                    }
                    .frame(width: CardConstants.whiteCircleSize)
                    .offset(x: CardConstants.lineXOffset + CardConstants.lineWidth / 2
                            - CardConstants.whiteCircleSize / 2)
                    Text("\(getDateTimeString(of: time))")
                        .font(Font.system(size: CardConstants.timeSize))
                        .foregroundColor(.gray)
                        .offset(x: CardConstants.lineXOffset + CardConstants.lineWidth / 2
                                - CardConstants.whiteCircleSize / 2)
                    Spacer()
                }
                .padding(.top, 15.0)
                
                ZStack {
                    RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                        .foregroundColor(.white)
                    content
                }
                .padding(.horizontal, CardConstants.lineXOffset - CardConstants.whiteCircleSize / 2)
            }
        }
    }
    
    struct CardConstants {
        static var lineXOffset = 30.0
        static var lineWidth = 3.0
        static var whiteCircleSize = 16.0
        static var circleSize = 9.0
        static var timeSize = 12.0
        static var cornerRadius = 6.0
    }
}

struct CompletedTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var completedTask: CompletedTask
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    timeline.taskCategory(id: completedTask.taskCategoryId).icon
                        .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35))
                    Text(timeline.taskCategory(id: completedTask.taskCategoryId).name)
                        .foregroundColor(.gray)
                }
                .font(.footnote)
                Spacer()
            }
            .frame(minWidth: 80, maxWidth: 80)
            Spacer()
            
            VStack (alignment: .leading) {
                Text("\(getTimeString(of: completedTask.beginTime)) - \(getTimeString(of: completedTask.endTime))")
                    .font(.headline)
                    .padding(.vertical, 2)
                
                HStack{
                    Image(systemName: "list.dash.header.rectangle")
                    Text(completedTask.taskDescription)
                }
                .padding(.leading, 10)
                .padding(.vertical, 1)
                .font(.footnote)
                .foregroundColor(.gray)
                
                HStack{
                    Image(systemName: "clock")
                    Text("\(timeStringFromSeconds(completedTask.durationInSeconds))")
                        .padding(.leading, 3)
                }
                .padding(.leading, 12)
                .font(.footnote)
                .foregroundColor(.gray)
            }
            
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4)
                .opacity(0.4)
                .foregroundColor(timeline.taskCategory(id: completedTask.taskCategoryId).color)
                .padding(8)
        }
        .padding()
    }
}

struct PlannedTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var plannedTask: PlannedTask
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    timeline.taskCategory(id: plannedTask.taskCategoryId).icon
                        .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35))
                    Text(timeline.taskCategory(id: plannedTask.taskCategoryId).name)
                        .foregroundColor(.gray)
                }
                .font(.footnote)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                            .foregroundColor(timeline.taskCategory(id: plannedTask.taskCategoryId).color)
                            .opacity(0.4)
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                        Text(plannedTask.attachedRepeatPlanId == nil ? "计划任务" : "重复计划")
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 10))
                }
            }
            .frame(minWidth: 80, maxWidth: 80)
            Spacer()
            
            VStack (alignment: .leading) {
                Text("\(getTimeString(of: plannedTask.beginTime)) - \(getTimeString(of: plannedTask.endTime))")
                    .font(.headline)
                    .padding(.vertical, 2)
                
                HStack{
                    Image(systemName: "list.dash.header.rectangle")
                    Text(plannedTask.taskDescription)
                }
                .padding(.leading, 10)
                .font(.footnote)
                .foregroundColor(.gray)
                
                HStack{
                    Image(systemName: "clock")
                    VStack(alignment: .leading) {
                        Text("计划时长：\(timeStringFromSeconds(plannedTask.durationInSeconds))")
                        
                        if plannedTask.isOver {
                            Text("实际时长：\(timeStringFromSeconds(plannedTask.totalExecutionTimeInSeconds))")
                        } else {
                            Text("实际时长：尚未执行")
                        }
                    }
                }
                .padding(.leading, 12)
                .padding(.vertical, 1)
                .font(.footnote)
                .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "rosette")
                        .foregroundColor(.gray)
                    if plannedTask.isOver {
                        Text("已完成 ✓")
                            .foregroundColor(.green)
                            .opacity(0.8)
                    } else {
                        Text("未完成 ✘")
                            .foregroundColor(.red)
                            .opacity(0.8)
                    }
                }
                .padding(.leading, 12)
                .font(.footnote)
                
            }
            
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4)
                .opacity(0.4)
                .foregroundColor(timeline.taskCategory(id: plannedTask.taskCategoryId).color)
                .padding(8)
        }
        .padding()
    }
}

struct TodoTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var todoTask: TodoTask
    
    var body: some View {
        HStack {
            if todoTask.isComplete {
                Image(systemName: "checkmark.square")
                    .onTapGesture {
                        withAnimation {
                            timeline.cancelCompletion(of: todoTask)
                        }
                    }
            } else {
                Image(systemName: "square")
                    .onTapGesture {
                        withAnimation {
                            timeline.completeTodoTask(todoTask, at: Date())
                        }
                    }
            }
            Text(todoTask.name)
                .font(.system(size: 15))
            
            Spacer()
            
            if todoTask.isComplete {
                Text("——于 \(getTimeString(of: todoTask.endTime!)) 完成")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4)
                .opacity(0.4)
                .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35, opacity: 0.8))
                .padding(8)
        }
        .padding()
    }

}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        ApplicationView()
            .environmentObject(timeline)
    }
}
