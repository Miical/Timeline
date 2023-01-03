//
//  ApplicationView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import SwiftUI

struct ApplicationView: View {
    @State var currentTab: Tab = .timeline
    @State var attachedPlannedTask: PlannedTask?
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                TimelineView(currentTab: $currentTab, attachedPlannedTask: $attachedPlannedTask)
                    .applyBackGround()
                    .tag(Tab.timeline)
                GlobalTodoView()
                    .applyBackGround()
                    .tag(Tab.todo)
                TimingView(attachedPlannedTask: $attachedPlannedTask)
                    .applyBackGround()
                    .tag(Tab.timing)
                Text("统计")
                    .applyBackGround()
                    .tag(Tab.statistics)
                MineView()
                    .applyBackGround()
                    .tag(Tab.mine)
            }
        }
        TimelineTabBar(currentTab: $currentTab)
    }
}
