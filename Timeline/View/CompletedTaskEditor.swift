//
//  CompletedTaskEditor.swift
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
                beginTime: Date(), endTime: Date(), taskCategoryId: -1, taskDescription: "", id: 0))
        } else {
            needToAdd = false
            self._completedTask = State(initialValue: completedTaskToEdit!)
        }
    }
    
    var body: some View {
        VStack {
            Form {
                nameSection
                taskDescriptionSection
                timeEditSection
            }
            Button("保存") {
                if needToAdd {
                    timeline.addCompletedTask(
                        taskCategoryId: completedTask.taskCategoryId,
                        taskDescription: completedTask.taskDescription,
                        beginTime: completedTask.beginTime,
                        endTime: completedTask.endTime)
                } else {
                    timeline.replaceCompletedTask(with: completedTask)
                }
            }.disabled(completedTask.taskCategoryId == -1)
        }
    }
    
    var nameSection: some View {
        Section(header: Text("类别")) {
             Menu {
                 ForEach (timeline.taskCategoryList) { taskCategory in
                     Button(taskCategory.name) {
                         completedTask.taskCategoryId = taskCategory.id
                     }
                }
            } label: {
                Text("类别：\(timeline.taskCategory(id: completedTask.taskCategoryId).name)")
            }
        }
    }
    
    var taskDescriptionSection: some View {
        Section(header: Text("任务描述")) {
            TextField("任务描述", text: $completedTask.taskDescription)
        }
    }
    
    var timeEditSection: some View {
        Section(header: Text("时间编辑")) {
            DatePicker("开始时间", selection: $completedTask.beginTime, displayedComponents: .hourAndMinute)
            DatePicker("结束时间", selection: $completedTask.endTime, displayedComponents: .hourAndMinute)
        }
    }
    
}
