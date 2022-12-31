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
            timelineBody2
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
    
    var timelineBody2: some View {
        VStack {
            ScrollView {
                ForEach(timeline.allRecords(for: Date())) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        Text("")
                            .frame(height: 80)
                            .timelineCardify(
                                color: timeline.taskCategory(id: completedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
                    case .plannedTask(let plannedTask):
                        Text("")
                            .frame(height: 80)
                            .timelineCardify(
                                color: timeline.taskCategory(id: plannedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
                    case .todoTask:
                        Text("")
                            .frame(height: 80)
                            .timelineCardify(
                                color: .yellow,
                                time: record.getBeginTime()!)
                    }
                }
            }
        }
    }
    
    var timelineBody: some View {
        VStack {
            ScrollView {
                ForEach(timeline.allRecords(for: Date())) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        NavigationLink(destination: CompletedTaskEditor(completedTask)) {
                            EventCard(record: record).padding(.all)
                        }
                    case .plannedTask(let plannedTask):
                        NavigationLink(destination: PlannedTaskEditor(plannedTask)) {
                            EventCard(record: record).padding(.all)
                                .onLongPressGesture {
                                    plannedTaskToExecute = plannedTask
                                }
                        }
                    case .todoTask(let todoTask) :
                        NavigationLink(destination: TodoTaskEditor(todoTask)){
                            EventCard(record: record).padding(.all)
                        }
                    }
                    
                }
            }
            .foregroundColor(.black)
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
                    Text("\(getTimeString(of: time))")
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
                        .padding(.horizontal, CardConstants.lineXOffset - CardConstants.whiteCircleSize / 2)
                    content
                }
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

struct EventCard: View {
    @EnvironmentObject var timeline: Timeline
    var record: Record
    
    var body: some View {
        switch record {
        case let .completedTask(completedTask):
            ZStack {
                VStack {
                    timeline.taskCategory(id: completedTask.taskCategoryId).icon
                    Text("已完成")
                    Text("\(getTimeString(of: completedTask.beginTime)) - \(getTimeString(of: record.getEndTime()!))")
                    Text("时长：\(completedTask.durationInSeconds) s")
                    Text("类别：\(timeline.taskCategory(id: completedTask.taskCategoryId).name)")
                        .foregroundColor(timeline.taskCategory(id: completedTask.taskCategoryId).color)
                    Text("任务描述：\(completedTask.taskDescription)")
                }
                
            }
        case let .plannedTask(plannedTask):
            ZStack {
                VStack {
                    timeline.taskCategory(id: plannedTask.taskCategoryId).icon
                    Text("计划")
                    Text("\(getTimeString(of: plannedTask.beginTime)) - \(getTimeString(of: record.getEndTime()!))")
                    Text("时长：\(plannedTask.durationInSeconds) s")
                    Text("类别：\(timeline.taskCategory(id: plannedTask.taskCategoryId).name)")
                        .foregroundColor(timeline.taskCategory(id: plannedTask.taskCategoryId).color)
                    Text("任务描述：\(plannedTask.taskDescription)")
                    Text("执行过程：\(plannedTask.totalExecutionTimeInSeconds) s")
                    Text("是否在执行：\(plannedTask.isExecuting ? "是" : "否")")
                }
            }
        case .todoTask(let todoTask) :
            ZStack {
                VStack {
                    Text("待办任务")
                    Text("任务名称：\(todoTask.name)")
                    Text("任务时间\(getTimeString(of: todoTask.beginTime!))")
                    if todoTask.isComplete {
                        Button("取消") {
                            timeline.cancelCompletion(of: todoTask)
                        }
                    } else {
                        Button("完成") {
                            timeline.completeTodoTask(todoTask, at: Date())
                        }
                    }
                }
            }
        }
    }
    
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        Text("HaHa")
            .timelineCardify(color: .red, time: Date())
    }
}
