//
//  PlannedTimingView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import SwiftUI

// 计时界面
struct PlannedTimingView: View {
    @EnvironmentObject var timeline: Timeline
    @State var plannedTask: PlannedTask
    
    @State var timer: Timer?
    @State var timeCostInSeconds = 0
    
    init(plannedTask: PlannedTask) {
        self._plannedTask = State(initialValue: plannedTask)
        self._timeCostInSeconds = State(initialValue: plannedTask.totalExecutionTimeInSeconds)
    }
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
            Text(timeline.taskCategory(id: plannedTask.taskCategoryId).name)
            Spacer()
            if !plannedTask.isOver {
                if !plannedTask.isExecuting {
                    Button(plannedTask.isExecuted ? "继续" : "开始") {
                        plannedTask.changeState(at: Date())
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            timeCostInSeconds = plannedTask.totalExecutionTimeInSeconds
                        }
                    }
                    if plannedTask.isExecuted {
                        Button("结束") {
                            plannedTask.isOver = true
                            timeline.modifyPlannedTask(with: plannedTask)
                            timer?.invalidate()
                        }
                    }
                } else {
                    Button("暂停") {
                        plannedTask.changeState(at: Date())
                        timer?.invalidate()
                    }
                    Button("结束") {
                        plannedTask.changeState(at: Date())
                        plannedTask.isOver = true
                        timeline.modifyPlannedTask(with: plannedTask)
                        timer?.invalidate()
                    }
                }
            }
        }
    }
    
    @State var selectedTaskCategory: TaskCategory?
}
