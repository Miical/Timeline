//
//  PlannedTaskEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import SwiftUI

struct PlannedTaskEditor: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var plannedTaskToEdit: PlannedTask?
    @State var plannedTask: PlannedTask
    @State var isAvailable: [Bool] = []
    let needToAdd: Bool
    
    var isRepeatPlan: Bool {
        get {
            plannedTask.attachedRepeatPlanId != nil
        }
        set {
            if newValue == true {
                plannedTask.attachedRepeatPlanId = 0
            } else {
                plannedTask.attachedRepeatPlanId = nil
            }
        }
    }
    
    init(_ plannedTaskToEdit: Binding<PlannedTask?>, needToAdd: Bool) {
        self.needToAdd = needToAdd
        self._plannedTaskToEdit = plannedTaskToEdit
        if needToAdd {
            self._plannedTask = State(initialValue: PlannedTask(
                beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "", id: 0))
        } else {
            self._plannedTask = State(initialValue: plannedTaskToEdit.wrappedValue!)
        }
        
        if plannedTaskToEdit.wrappedValue?.attachedRepeatPlanId != nil {
            self._isAvailable = State(initialValue: Array(repeating: true, count: 7))
        }
    }
    
    var body: some View {
        VStack {
            if needToAdd {
                TypeSelector(type: Binding(
                    get: { plannedTask.attachedRepeatPlanId != nil },
                    set: {
                        if $0 == true { plannedTask.attachedRepeatPlanId = 0; isAvailable = Array(repeating: true, count: 7) }
                        else { plannedTask.attachedRepeatPlanId = nil; isAvailable = [] }
                    }), trueTypeName: "添加重复计划", falseTypeName: "添加计划")
            }
            TextEditor(name: "任务描述", text: $plannedTask.taskDescription, wordsLimit: 50)
            TaskCategorySelector(taskCategoryId: $plannedTask.taskCategoryId)
            TimeEditor(name: "开始时间", time: $plannedTask.beginTime)
            TimeEditor(name: "结束时间", time: $plannedTask.endTime)
            if isAvailable.count == 7 {
                DaysSelector(isAvailable: $isAvailable)
            }
            
        }
        .turnToEditor(isPresent: Binding(
            get: { plannedTaskToEdit != nil },
            set: { if $0 == false { plannedTaskToEdit = nil }}),
                      title: "编辑\(isRepeatPlan ? "重复" : "")计划任务") {
            
            if needToAdd {
                timeline.addPlannedTask(
                    taskCategoryId: plannedTask.taskCategoryId,
                    taskDescription: plannedTask.taskDescription,
                    beginTime: plannedTask.beginTime,
                    endTime: plannedTask.endTime,
                    isAvailable: isAvailable.isEmpty ? nil : isAvailable)
            } else {
                if isRepeatPlan {
                    timeline.replaceRepeatPlan(with: RepeatPlan(
                        task: Record.plannedTask(plannedTask),
                        isAvailable: isAvailable))
                } else {
                    timeline.modifyPlannedTask(with: plannedTask)
                }
            }
        }
        .onAppear{
            if isAvailable.count == 7 {
                isAvailable = timeline.repeatPlan(with: plannedTask.attachedRepeatPlanId!).isAvailable
            }
        }
    }
}
