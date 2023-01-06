//
//  TodoTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import SwiftUI

struct TodoTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var todoTaskToEdit: TodoTask?
    @State var todoTask: TodoTask
    @State var isAvailable: [Bool] = []
    @State var beginTime: Date
    let needToAdd: Bool
    
    var isRepeatPlan: Bool {
        get {
            todoTask.attachedRepeatPlanId != nil
        }
        set {
            if newValue == true {
                todoTask.attachedRepeatPlanId = 0
            } else {
                todoTask.attachedRepeatPlanId = nil
            }
        }
    }
    
    init(_ todoTaskToEdit: Binding<TodoTask?>, needToAdd: Bool) {
        self.needToAdd = needToAdd
        self._todoTaskToEdit = todoTaskToEdit
        if needToAdd {
            self._todoTask = State(initialValue: TodoTask(
                name: "", beginTime: Date(), id: 0))
            self._beginTime = State(initialValue: Date())
        } else {
            self._todoTask = State(initialValue: todoTaskToEdit.wrappedValue!)
            self._beginTime = State(initialValue: todoTaskToEdit.wrappedValue!.beginTime!)
        }
        
        if todoTaskToEdit.wrappedValue?.attachedRepeatPlanId != nil {
            self._isAvailable = State(initialValue: Array(repeating: true, count: 7))
        }
    }
    
    var body: some View {
        VStack {
            if needToAdd {
                TypeSelector(type: Binding(
                    get: { todoTask.attachedRepeatPlanId != nil },
                    set: {
                        if $0 == true { todoTask.attachedRepeatPlanId = 0; isAvailable = Array(repeating: true, count: 7) }
                        else { todoTask.attachedRepeatPlanId = nil; isAvailable = [] }
                    }), trueTypeName: "添加重复待办", falseTypeName: "添加待办")
            }
            TextEditor(name: "名称", text: $todoTask.name, wordsLimit: 50)
            if isAvailable.isEmpty {
                DateEditor(name: "日期", date: $beginTime)
            }
            TimeEditor(name: "计划时间", time: $beginTime)
            if isAvailable.count == 7 {
                DaysSelector(isAvailable: $isAvailable)
            }
            
        }
        .turnToEditor(isPresent: Binding(
            get: { todoTaskToEdit != nil },
            set: { if $0 == false { todoTaskToEdit = nil }}),
                      title: "\(needToAdd ? "新建" : "编辑")\(isRepeatPlan ? "重复" : "")待办") {
            
            if needToAdd {
                timeline.addTodoTask(
                    taskName: todoTask.name,
                    beginTime: beginTime,
                    isAvailable: isAvailable.isEmpty ? nil : isAvailable)
            } else {
                todoTask.beginTime = beginTime
                if isRepeatPlan {
                    timeline.replaceRepeatPlan(with: RepeatPlan(
                        task: Record.todoTask(todoTask),
                        isAvailable: isAvailable))
                } else {
                    timeline.replaceTodoTask(with: todoTask)
                }
            }
        }
        .onAppear{
            if isAvailable.count == 7 {
                isAvailable = timeline.repeatPlan(with: todoTask.attachedRepeatPlanId!).isAvailable
            }
        }
    }
}
