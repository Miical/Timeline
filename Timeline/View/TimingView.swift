//
//  TimingView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

// 计时界面
struct TimingView: View {
    typealias OngoingTask = TimelineManager.OngoingTask
    @EnvironmentObject var timeline: Timeline
    
    var body: some View {
        VStack {
            Spacer()
            if timeline.ongoingTask == nil {
                Button("Start") {
                    timeline.startATask(of: timeline.taskCategoryList[0], at: Date())
                }
            } else {
                Button("End") {
                    timeline.endTask(at: Date())
                }
            }
        }
    }
}

struct TimingView_Previews: PreviewProvider {
    static var previews: some View {
        TimingView()
            .environmentObject(Timeline())
    }
}
