//
//  CompletedTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/28.
//

import SwiftUI


struct CompletedTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var completedTaskToEdit: CompletedTask?
    @State var completedTask: CompletedTask
    let needToAdd: Bool
    
    init(_ completedTaskToEdit: Binding<CompletedTask?>, needToAdd: Bool) {
        self.needToAdd = needToAdd
        self._completedTaskToEdit = completedTaskToEdit
        if needToAdd == false {
            self._completedTask = State(initialValue: CompletedTask(
                beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "", id: 0))
        } else {
            self._completedTask = State(initialValue: completedTaskToEdit.wrappedValue!)
        }
    }
    
    var body: some View {
        VStack {
            TextEditor(name: "任务描述", text: $completedTask.taskDescription, wordsLimit: 50)
            TaskCategorySelector(taskCategoryId: $completedTask.taskCategoryId)
            TimeEditor(name: "开始时间", time: $completedTask.beginTime)
            TimeEditor(name: "结束时间", time: $completedTask.endTime)
            
        }
        .turnToEditor(isPresent: Binding(
            get: { completedTaskToEdit != nil },
            set: { if $0 == false { completedTaskToEdit = nil }}),
                      title: "编辑已完成任务") {
            
            if needToAdd {
                timeline.addCompletedTask(
                    taskCategoryId: completedTask.taskCategoryId,
                    taskDescription: completedTask.taskDescription,
                    beginTime: completedTask.beginTime,
                    endTime: completedTask.endTime)
            } else {
                timeline.replaceCompletedTask(with: completedTask)
            }
        }
    }
}
