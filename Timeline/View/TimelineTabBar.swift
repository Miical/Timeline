//
//  TimelineTabBar.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import SwiftUI

struct TimelineTabBar: View {
    @Binding var currentTab: Tab
    @State var yOffset: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            currentTab = tab
                            yOffset = -60
                        }
                        
                        withAnimation(.easeInOut(duration: 0.1).delay(0.07)) {
                            yOffset = 0
                        }
                    } label: {
                        Image(systemName: tab.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? .black : .gray)
                            .scaleEffect(currentTab == tab && yOffset != 0 ? 1.5 : 1)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                Circle()
                    .fill(timelineThemeColor)
                    .opacity(0.9)
                    .frame(width: 20, height: 20)
                    .offset(x: 10, y: yOffset)
                    .offset(x: indicatorOffset(width: width))
            }
            
        }
        .frame(height: 20)
        .padding(.bottom, 5)
        .padding([.horizontal, .top])
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        if index == 0 { return 0 }
        
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        
        return index * buttonWidth
    }
    
    func getIndex() -> Int {
        switch currentTab {
        case .timeline:
            return 0
        case .todo:
            return 1
        case .timing:
            return 2
        case .statistics:
            return 3
        case .mine:
            return 4
        }
    }
}

enum Tab: String, CaseIterable {
    case timeline = "calendar.day.timeline.left"
    case todo = "checklist"
    case timing = "timer"
    case statistics = "list.bullet.rectangle"
    case mine = "person"
}

