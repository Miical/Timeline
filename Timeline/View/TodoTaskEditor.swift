//
//  TodoTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import SwiftUI

struct TodoTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @State var todoTask: TodoTask
    @State var beginTime: Date
    let needToAdd: Bool
    
    init(_ todoTaskToEdit: TodoTask?) {
        if todoTaskToEdit == nil {
            needToAdd = true
            self._todoTask = State(initialValue: TodoTask(
                name: "", beginTime: Date(), id: 0))
            self._beginTime = State(initialValue: Date())
        } else {
            needToAdd = false
            self._todoTask = State(initialValue: todoTaskToEdit!)
            self._beginTime = State(initialValue: todoTaskToEdit!.beginTime!)
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
                    timeline.addTodoTask(taskName: todoTask.name, beginTime: beginTime)
                } else {
                    todoTask.beginTime = beginTime
                    timeline.replaceTodoTask(with: todoTask)
                }
            }.disabled(todoTask.name == "")
        }
    }
    
    var nameSection: some View {
        Section(header: Text("任务名称")) {
            TextField("任务名称", text: $todoTask.name)
        }
    }
    
    var timeEditSection: some View {
        Section(header: Text("时间编辑")) {
            DatePicker("开始时间", selection: $beginTime, displayedComponents: .hourAndMinute)
        }
    }
    
}
