//
//  TimelineView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var timeline: Timeline
    
    var body: some View {
        TabView {
            timelineBody.tabItem {
                Image(systemName: "1.circle")
                Text("Tab 1")
            }
            TimingView().tabItem {
                Image(systemName: "2.circle")
                Text("Tab 2")
            }
        }
    }
    
    var timelineBody: some View {
        VStack {
            Text("时光轴")
            ScrollView {
                VStack {
                    ForEach(timeline.allRecord(for: Date())) { record in
                        EventCard(record: record).padding(.all)
                    }
                }
            }
        }
    }
    
}

struct EventCard: View {
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
                    Text("类别：\(completedTask.taskCategory.name)")
                }
                
            }
        case let .plannedTask(plannedTask):
            ZStack {
                Rectangle().stroke(lineWidth: 3)
                VStack {
                    Text("计划")
                    Text("\(getTimeText(of: plannedTask.beginTime)) - \(getTimeText(of: record.getEndTime()!))")
                    Text("时长：\(plannedTask.durationInSeconds) s")
                    Text("类别：\(plannedTask.taskCategory.name)")
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
