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
    
    @State var isPresentSideBar = false
    @State var selectedDate = Date()
    
    @State var isPresentSideBarForStatistics = false
    @State var selectedDateForStatistics = Date()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                TimelineView(currentTab: $currentTab, attachedPlannedTask: $attachedPlannedTask,
                             selectedDate: $selectedDate, isPresentSideBar: $isPresentSideBar)
                    .applyBackGround()
                    .tag(Tab.timeline)
                GlobalTodoView()
                    .applyBackGround()
                    .tag(Tab.todo)
                TimingView(attachedPlannedTask: $attachedPlannedTask)
                    .applyBackGround()
                    .tag(Tab.timing)
                StatisticsView(selectedDate: $selectedDateForStatistics,
                               isPresentSideBar: $isPresentSideBarForStatistics)
                    .applyBackGround()
                    .tag(Tab.statistics)
                MineView()
                    .applyBackGround()
                    .tag(Tab.mine)
            }
            TimelineTabBar(currentTab: $currentTab)
        }
        .dateSideBar(isPresent: $isPresentSideBar, date: $selectedDate)
        .dateSideBar(isPresent: $isPresentSideBarForStatistics, date: $selectedDateForStatistics)
    }
}
