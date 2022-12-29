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
    @State var taskDescription: String = ""
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
            taskCategoriesBody
            Spacer()
            TextField("任务描述", text: $taskDescription)
            Spacer()
            if timeline.ongoingTask == nil {
                Button("开始") {
                    startTask()
                }
            } else {
                Button("切换任务") {
                    endTask()
                    startTask()
                }
                Button("结束") { endTask() }
            }
        }
    }
    
    @State var selectedTaskCategory: TaskCategory?
    
    var taskCategoriesBody: some View {
        VStack {
            ForEach(timeline.taskCategoryList) { taskCategory in
                Text(taskCategory.name).onTapGesture {
                    selectedTaskCategory = taskCategory
                }.font(selectedTaskCategory?.id == taskCategory.id ? .title : .title2)
            }
        }
    }
    
    func startTask() {
        if selectedTaskCategory != nil {
            timeCostInSeconds = 0
            timeline.startATask(of: selectedTaskCategory!, with: taskDescription, at: Date())
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                timeCostInSeconds = Calendar.current.dateComponents([.second],
                    from: timeline.ongoingTask!.2, to: Date()).second!
            }
        }
    }
    
    func endTask() {
        timeline.endTask(at: Date())
        timer?.invalidate()
    }
}

struct TimingView_Previews: PreviewProvider {
    static var previews: some View {
        TimingView()
            .environmentObject(Timeline())
    }
}
