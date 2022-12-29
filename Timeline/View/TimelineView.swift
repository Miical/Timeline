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
    
    var body: some View {
        TabView {
            timelineBody.tabItem {
                Image(systemName: "1.circle")
                Text("时间轴")
            }
            TimingView().tabItem {
                Image(systemName: "2.circle")
                Text("计时")
            }
            TaskCategoryManagementView().tabItem {
                Image(systemName: "3.circle")
                Text("类别管理")
            }
        }
    }
    
    var timelineBody: some View {
        NavigationView {
            List {
                ForEach(timeline.allRecord(for: Date())) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        NavigationLink(destination: CompletedTaskEditor(completedTask)) {
                            EventCard(record: record).padding(.all)
                        }
                    default:
                        Text("None")
                    }
                    
                }
                .onDelete { indexSet in
                    var idSet = IndexSet()
                    for index in indexSet {
                        idSet.insert(timeline.allRecord(for: Date())[index].id)
                    }
                    timeline.removeRecord(at: idSet)
                }
            }
            .navigationTitle("时光轴")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
            }
            .popover(isPresented: $completedTaskEditor, content: { CompletedTaskEditor(nil) })
            
            Spacer()
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
                VStack {
                    Text("已完成")
                    Text("\(getTimeText(of: completedTask.beginTime)) - \(getTimeText(of: record.getEndTime()!))")
                    Text("时长：\(completedTask.durationInSeconds) s")
                    Text("类别：\(completedTask.taskCategoryName)")
                        .foregroundColor(timeline.getThemeColor(of: completedTask.taskCategoryName))
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
