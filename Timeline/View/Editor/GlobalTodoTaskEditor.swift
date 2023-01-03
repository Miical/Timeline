//
//  GlobalTodoTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/3.
//

import SwiftUI

struct GlobalTodoTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @State var todoTask: TodoTask
    @Binding var isPresent: Bool
    
    var needToAdd: Bool
    
    init(_ globalTodoTaskToEdit: TodoTask?, isPresent: Binding<Bool>) {
        self._isPresent = isPresent
        if let globalTodoTaskToEdit = globalTodoTaskToEdit {
            self._todoTask = State(initialValue: globalTodoTaskToEdit)
            needToAdd = false
        } else {
            self._todoTask = State(initialValue: TodoTask(name: "", id: 0))
            needToAdd = true
        }
    }
    
    var body: some View {
        VStack {
            TextEditor(name: "名称", text: $todoTask.name, wordsLimit: 50)
        }
        .turnToEditor(isPresent: $isPresent, title: "编辑待办", onSave: {
            if needToAdd {
                timeline.addGlobalTodoTask(taskName: todoTask.name)
            } else {
                timeline.replaceGlobalTodoTask(with: todoTask)
            }
        })
    }
}
