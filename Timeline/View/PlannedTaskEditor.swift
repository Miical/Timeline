//
//  PlannedTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import SwiftUI


struct PlannedTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @State var plannedTask: PlannedTask
    let needToAdd: Bool
    
    init(_ plannedTaskToEdit: PlannedTask?) {
        if plannedTaskToEdit == nil {
            needToAdd = true
            self._plannedTask = State(initialValue: PlannedTask(
                beginTime: Date(), endTime: Date(), taskCategoryName: "", taskDescription: "", id: 0))
        } else {
            needToAdd = false
            self._plannedTask = State(initialValue: plannedTaskToEdit!)
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
                        taskCategoryName: plannedTask.taskCategoryName,
                        taskDescription: plannedTask.taskDescription,
                        beginTime: plannedTask.beginTime,
                        endTime: plannedTask.endTime)
                } else {
                    timeline.modifyCompletedTask(with: plannedTask)
                }
            }.disabled(plannedTask.taskCategoryName == "")
        }
    }
    
    var nameSection: some View {
        Section(header: Text("类别")) {
             Menu {
                 ForEach (timeline.taskCategoryList) { taskCategory in
                     Button(taskCategory.name) {
                         plannedTask.taskCategoryName = taskCategory.name
                     }
                }
            } label: {
                Text("类别：\(plannedTask.taskCategoryName)")
            }
        }
    }
    
    var taskDescriptionSection: some View {
        Section(header: Text("任务描述")) {
            TextField("任务描述", text: $plannedTask.taskDescription)
        }
    }
    
    var timeEditSection: some View {
        Section(header: Text("时间编辑")) {
            DatePicker("开始时间", selection: $plannedTask.beginTime, displayedComponents: .hourAndMinute)
            DatePicker("结束时间", selection: $plannedTask.endTime, displayedComponents: .hourAndMinute)
        }
    }
    
}
