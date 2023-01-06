//
//  TimelineCard.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/1.
//

import SwiftUI

struct TimelineCardify: ViewModifier {
    var themeColor: Color
    var time: Date
    
    func body(content: Content) -> some View {
        ZStack {
            HStack {
                Rectangle()
                    .shadow(color: Color(red: 0.9, green: 0.9, blue: 0.9), radius: 3)
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
                            .shadow(color: Color(red: 0.9, green: 0.9, blue: 0.9), radius: 3)
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
                        .shadow(color: Color(red: 0.92, green: 0.92, blue: 0.92), radius: 5)
                    content
                }
                .padding(.horizontal, CardConstants.lineXOffset - CardConstants.whiteCircleSize / 2)
            }
        }
        .transition(.move(edge: .trailing))
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
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
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
}

struct PlannedTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var plannedTask: PlannedTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
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
}

struct TodoTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var todoTask: TodoTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
            HStack {
                if todoTask.isComplete {
                    Image(systemName: "checkmark.square")
                        .onTapGesture {
                            timeline.cancelCompletion(of: todoTask)
                        }
                } else {
                    Image(systemName: "square")
                        .onTapGesture {
                            timeline.completeTodoTask(todoTask, at: Date())
                        }
                }
                
                if todoTask.isComplete {
                    Text(todoTask.name)
                        .font(.system(size: 15))
                        .strikethrough()
                } else {
                    Text(todoTask.name)
                        .font(.system(size: 15))
                }
                
                Spacer()
                
                if todoTask.isComplete {
                    VStack(alignment: .trailing) {
                        Text("——完成时间")
                        Text(getDateTimeString(of: todoTask.endTime!))
                    }
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

}

