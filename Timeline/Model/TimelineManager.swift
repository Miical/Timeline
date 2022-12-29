//
//  TimelineManager.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TimelineManager {
    private(set) var recordList: [Record]
    
    init() {
        recordList = []
    }
    
    
    func allRecord(for date: Date) -> [Record] {
        return recordList
            .filter { Calendar.current.isDate(date, inSameDayAs: $0.getBeginTime()!) }
            .sorted { record1, record2 in record1.getBeginTime()! < record2.getBeginTime()! }
    }
    
    // MARK: - 记录管理
    
    var recordCount: Int = 0
    
    mutating func removeRecord(at idSet: IndexSet) {
        for id in idSet {
            recordList.removeAll(where: { $0.id == id })
        }
    }
    
    // MARK: - 已完成任务管理
    
    mutating func addCompletedTask(taskCategoryName: String, taskDescription: String,
                                   beginTime: Date,  endTime: Date) {
        recordList.append(.completedTask(CompletedTask(
            beginTime: beginTime,
            endTime: endTime,
            taskCategoryName: taskCategoryName,
            taskDescription: taskDescription,
            id: recordCount)))
        recordCount += 1
    }
    
    mutating func replaceCompletedTask(with newCompletedTask: CompletedTask) {
        recordList.removeAll(where: { $0.id == newCompletedTask.id })
        recordList.append(Record.completedTask(newCompletedTask))
    }
    
    // MARK: - 计划任务管理
    
    mutating func addPlannedTask(taskCategoryName: String, taskDescription: String,
                                 beginTime: Date,  endTime: Date) {
        recordList.append(.plannedTask(PlannedTask(
            beginTime: beginTime,
            endTime: endTime,
            taskCategoryName: taskCategoryName,
            taskDescription: taskDescription,
            id: recordCount)))
        recordCount += 1
    }
    
    /// 将列表中相同id的元素信息替换为给定元素信息，但保持执行的相关信息不变。
    mutating func modifyPlannedTask(with newPlannedTask: PlannedTask) {
        let oldRecord = recordList.first(where: { $0.id == newPlannedTask.id })!
        switch oldRecord {
        case .plannedTask(let oldTask):
            var task = newPlannedTask
            task.taskExecution = oldTask.taskExecution
            recordList.removeAll(where: { $0.id == newPlannedTask.id })
            recordList.append(Record.plannedTask(newPlannedTask))
        default:
            break
        }
    }
    
    // MARK: - 代办任务管理
    
    mutating func addTodoTask(taskName: String, beginTime: Date) {
        recordList.append(.todoTask(TodoTask(
            name: taskName, beginTime: beginTime,id: recordCount)))
        recordCount += 1
    }
    
    mutating func completeTodoTask(_ todoTask: TodoTask, at time: Date) {
        recordList.removeAll(where: { $0.id == todoTask.id })
        var newTodoTask = todoTask
        newTodoTask.complete(at: time)
        recordList.append(Record.todoTask(newTodoTask))
    }
    
    mutating func cancelCompletion(of todoTask: TodoTask) {
        recordList.removeAll(where: { $0.id == todoTask.id })
        var newTodoTask = todoTask
        newTodoTask.cancleCompletion()
        recordList.append(Record.todoTask(newTodoTask))
    }
    
    mutating func replaceTodoTask(with newTodoTask: TodoTask) {
        recordList.removeAll(where: { $0.id == newTodoTask.id })
        recordList.append(Record.todoTask(newTodoTask))
    }
    
    // MARK: - 管理任务执行
    
    // 正在进行的任务，任务类别, 任务描述，以及任务的开始时间
    typealias OngoingTask = (String, String, Date)?
    private(set) var ongoingTask: OngoingTask = nil
    
    mutating func startATask(of taskCategory: TaskCategory, with taskDescription: String, at time: Date) {
        assert(ongoingTask == nil, "there is a task in progress")
        ongoingTask = (taskCategory.name, taskDescription, time)
    }
    
    mutating func endTask(at time: Date) {
        addCompletedTask(
            taskCategoryName: ongoingTask!.0,
            taskDescription: ongoingTask!.1,
            beginTime: ongoingTask!.2,
            endTime: time)
        ongoingTask = nil
    }
}
