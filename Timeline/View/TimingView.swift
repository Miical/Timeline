//
//  TimingView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

// 计时界面
struct TimingView: View {
    @EnvironmentObject var timeline: Timeline
    
    @State var timer: Timer?
    @State var timeCostInSeconds: Int = 0
    var body: some View {
        VStack {
            Spacer()
            let timeText = String(format: "%02d:%02d:%02d",
                   timeCostInSeconds / 3600,
                   timeCostInSeconds % 3600 / 60,
                   timeCostInSeconds % 60)
            Text(timeText)
                .font(.largeTitle)
                .fontWeight(.medium)
            Spacer()
            if timeline.ongoingTask == nil {
                Button("Start") {
                    timeCostInSeconds = 0
                    timeline.startATask(of: timeline.taskCategoryList[0], at: Date())
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        timeCostInSeconds = Calendar.current.dateComponents([.second],
                            from: timeline.ongoingTask!.1, to: Date()).second!
                    }
                }
            } else {
                Button("End") {
                    timeline.endTask(at: Date())
                    timer?.invalidate()
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
