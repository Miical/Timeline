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

struct EventCard: View {
    @EnvironmentObject var timeline: Timeline
    var record: Record
    
    var body: some View {
        switch record {
        case let .completedTask(completedTask):
            ZStack {
                Rectangle().stroke(lineWidth: 3)
                VStack {
                    Text("已完成")
                    Text("\(getTimeText(of: completedTask.beginTime)) - \(getTimeText(of: record.getEndTime()!))")
                    Text("时长：\(completedTask.durationInSeconds) s")
                    Text("类别：\(completedTask.taskCategoryName)")
                        .foregroundColor(timeline.getThemeColor(of: completedTask.taskCategoryName))
                    Text("任务描述：\(completedTask.taskDescription)")
                }
                
            }
        case let .plannedTask(plannedTask):
            ZStack {
                Rectangle().stroke(lineWidth: 3)
                VStack {
                    Text("计划")
                    Text("\(getTimeText(of: plannedTask.beginTime)) - \(getTimeText(of: record.getEndTime()!))")
                    Text("时长：\(plannedTask.durationInSeconds) s")
                    Text("类别：\(plannedTask.taskCategoryName)")
                        .foregroundColor(timeline.getThemeColor(of: plannedTask.taskCategoryName))
                    Text("任务描述：\(plannedTask.taskDescription)")
                    Text("执行过程：\(plannedTask.totalExecutionTimeInSeconds) s")
                    Text("是否在执行：\(plannedTask.isExecuting ? "是" : "否")")
                }
            }
        case .todoTask(let todoTask) :
            ZStack {
                Rectangle().stroke(lineWidth: 3)
                VStack {
                    Text("待办任务")
                    Text("任务名称：\(todoTask.name)")
                    Text("任务时间\(getTimeText(of: todoTask.beginTime!))")
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
    
    // 将 Date 类型转换为 hh:mm:ss 格式的字符串
    func getTimeText(of time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: time)
    }
    
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .environmentObject(Timeline())
    }
}
