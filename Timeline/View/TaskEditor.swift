//
//  TaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/28.
//

import SwiftUI


struct CompletedTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @State var completedTask: CompletedTask
    let needToAdd: Bool
    
    init(_ completedTaskToEdit: CompletedTask?) {
        if completedTaskToEdit == nil {
            needToAdd = true
            self._completedTask = State(initialValue: CompletedTask(
                beginTime: Date(), endTime: Date(), taskCategoryName: "", id: 0))
        } else {
            needToAdd = false
            self._completedTask = State(initialValue: completedTaskToEdit!)
        }
    }
    
    var body: some View {
        VStack {
            Form {
                nameSection
                timeEditSection
            }
            Button("保存") {
                if needToAdd {
                    timeline.addCompletedTask(
                        taskCategoryName: completedTask.taskCategoryName,
                        beginTime: completedTask.beginTime,
                        endTime: completedTask.endTime)
                } else {
                    timeline.replaceCompletedTask(with: completedTask)
                }
            }.disabled(completedTask.taskCategoryName == "")
        }
    }
    
    var nameSection: some View {
        Section(header: Text("类别")) {
             Menu {
                 ForEach (timeline.taskCategoryList) { taskCategory in
                     Button(taskCategory.name) {
                         completedTask.taskCategoryName = taskCategory.name
                     }
                }
            } label: {
                Text("类别：\(completedTask.taskCategoryName)")
            }
        }
    }
    
    var timeEditSection: some View {
        Section(header: Text("时间编辑")) {
            DatePicker("开始时间", selection: $completedTask.beginTime, displayedComponents: .hourAndMinute)
            DatePicker("结束时间", selection: $completedTask.endTime, displayedComponents: .hourAndMinute)
        }
    }
    
}
