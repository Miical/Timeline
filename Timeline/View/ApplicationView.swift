//
//  ApplicationView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import SwiftUI

struct ApplicationView: View {
    @State var currentTab: Tab = .timeline
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                TimelineView()
                    .applyBackGround()
                    .tag(Tab.timeline)
                GlobalTodoView()
                    .applyBackGround()
                    .tag(Tab.todo)
                TimingView()
                    .applyBackGround()
                    .tag(Tab.timing)
                Text("统计")
                    .applyBackGround()
                    .tag(Tab.statistics)
                TaskCategoryManagementView()
                    .applyBackGround()
                    .tag(Tab.mine)
            }
        }
        TimelineTabBar(currentTab: $currentTab)
    }
}
