//
//  TimelineManager.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TimelineManager: Codable {
    private(set) var recordList: [Record] = []
    private(set) var globalTodoTasks: [TodoTask] = []
    private(set) var repeatPlans: [RepeatPlan] = []
    
    init() {}
    init(json: Data) throws {
        self = try JSONDecoder().decode(TimelineManager.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try TimelineManager(json: data)
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
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
    
    mutating func addCompletedTask(taskCategoryId: Int, taskDescription: String,
                                   beginTime: Date,  endTime: Date) {
        recordList.append(.completedTask(CompletedTask(
            beginTime: beginTime,
            endTime: endTime,
            taskCategoryId: taskCategoryId,
            taskDescription: taskDescription,
            id: recordCount)))
        recordCount += 1
    }
    
    mutating func replaceCompletedTask(with newCompletedTask: CompletedTask) {
        recordList.removeAll(where: { $0.id == newCompletedTask.id })
        recordList.append(Record.completedTask(newCompletedTask))
    }
    
    // MARK: - 计划任务管理
    
    /// 添加计划任务
    /// 若指定了isAvailable则该计划任务为重复计划
    mutating func addPlannedTask(taskCategoryId: Int, taskDescription: String,
                                 beginTime: Date,  endTime: Date,
                                 isAvailable: [Bool]? = nil,
                                 attachedRepeatPlanId: Int? = nil) {
        if isAvailable == nil {
            recordList.append(.plannedTask(PlannedTask(
                beginTime: beginTime,
                endTime: endTime,
                taskCategoryId: taskCategoryId,
                taskDescription: taskDescription,
                id: recordCount,
                attachedRepeatPlanId: attachedRepeatPlanId)))
        } else {
            repeatPlans.append(RepeatPlan(
                task: .plannedTask(PlannedTask(
                    beginTime: beginTime,
                    endTime: endTime,
                    taskCategoryId: taskCategoryId,
                    taskDescription: taskDescription,
                    id: recordCount,
                    attachedRepeatPlanId: recordCount)),
                isAvailable: isAvailable!
            ))
        }
        recordCount += 1
    }
    
    mutating func addPlannedTask(_ plannedTask: PlannedTask, with attachedRepeatPlanId: Int) {
        var newPlannedTask = plannedTask
        newPlannedTask.attachedRepeatPlanId = attachedRepeatPlanId
        newPlannedTask.id = recordCount
        recordCount += 1
        recordList.append(.plannedTask(newPlannedTask))
    }
    
    /// 将列表中相同id的元素信息替换为给定元素信息，但保持执行的相关信息不变。
    mutating func modifyPlannedTask(with newPlannedTask: PlannedTask) {
        let oldRecord = recordList.first(where: { $0.id == newPlannedTask.id })
        if let oldRecord {
            switch oldRecord {
            case .plannedTask(let oldTask):
                var task = newPlannedTask
                task.taskExecution = oldTask.taskExecution
                recordList.removeAll(where: { $0.id == newPlannedTask.id })
                recordList.append(Record.plannedTask(newPlannedTask))
            default:
                break
            }
        } else {
            addPlannedTask(newPlannedTask, with: newPlannedTask.id)
        }
    }
    
    // MARK: - 待办任务管理
    
    /// 添加待办任务
    /// 若指定了isAvailable则该计划任务为重复待办任务
    mutating func addTodoTask(taskName: String, beginTime: Date,
                              isAvailable: [Bool]? = nil,
                              attachedRepeatPlanId: Int? = nil) {
        if isAvailable == nil {
            recordList.append(.todoTask(TodoTask(
                name: taskName, beginTime: beginTime,id: recordCount,
                attachedRepeatPlanId: attachedRepeatPlanId)))
        } else {
            repeatPlans.append(RepeatPlan(
                task: .todoTask(TodoTask(
                    name: taskName, beginTime: beginTime,
                    id: recordCount, attachedRepeatPlanId: recordCount)),
                isAvailable: isAvailable!))
        }
        recordCount += 1
    }
    
    mutating func addTodoTask(_ todoTask: TodoTask, with attachedRepeatPlanId: Int) {
        var newTodoTask = todoTask
        newTodoTask.attachedRepeatPlanId = attachedRepeatPlanId
        newTodoTask.id = recordCount
        recordCount += 1
        recordList.append(.todoTask(newTodoTask))
    }
    
    mutating func completeTodoTask(_ todoTask: TodoTask, at time: Date) {
        var newTodoTask = todoTask
        newTodoTask.complete(at: time)
        replaceTodoTask(with: newTodoTask)
    }
    
    mutating func cancelCompletion(of todoTask: TodoTask) {
        var newTodoTask = todoTask
        newTodoTask.cancelCompletion()
        replaceTodoTask(with: newTodoTask)
    }
    
    mutating func replaceTodoTask(with newTodoTask: TodoTask) {
        if recordList.contains(where: { $0.id == newTodoTask.id }) {
            recordList.removeAll(where: { $0.id == newTodoTask.id })
            recordList.append(Record.todoTask(newTodoTask))
        } else {
            addTodoTask(newTodoTask, with: newTodoTask.id)
        }
    }
    
    mutating func addGlobalTodoTask(taskName: String) {
        globalTodoTasks.append(TodoTask(name: taskName, id: recordCount))
        recordCount += 1
    }
    
    mutating func completeGlobalTodoTask(_ todoTask: TodoTask, at time: Date) {
        globalTodoTasks[todoTask].complete(at: time)
    }
    
    mutating func cancelGlobalCompletion(of todoTask: TodoTask) {
        globalTodoTasks[todoTask].cancelCompletion()
    }
    
    mutating func replaceGlobalTodoTask(with newTodoTask: TodoTask) {
        globalTodoTasks[newTodoTask] = newTodoTask
    }
    
    mutating func removeGlobalTodoTask(at idSet: IndexSet) {
        for id in idSet {
            globalTodoTasks.removeAll(where: { $0.id == id })
        }
    }
    
    // MARK: - 重复计划管理
    
    func allRepeatPlans(for date: Date) -> [RepeatPlan] {
        return repeatPlans.filter({ $0.isAvailableAt(date: date) })
    }
    
    mutating func removeRepeatPlan(at idSet: IndexSet) {
        for id in idSet {
            repeatPlans.removeAll(where: { $0.id == id })
        }
    }
    
    mutating func replaceRepeatPlan(with newNepeatPlan: RepeatPlan) {
        repeatPlans[newNepeatPlan] = newNepeatPlan
    }
    
    
    // MARK: - 管理任务执行
    
    // 正在进行的任务，任务类别, 任务描述，以及任务的开始时间
    struct OngoingTask: Codable {
        var taskCategoryId: Int
        var taskDescription: String
        var beginTime: Date
    }
    private(set) var ongoingTask: OngoingTask? = nil
    
    mutating func startATask(of taskCategory: TaskCategory, with taskDescription: String, at time: Date) {
        assert(ongoingTask == nil, "there is a task in progress")
        ongoingTask = OngoingTask(taskCategoryId: taskCategory.id,
                                  taskDescription: taskDescription, beginTime: time)
    }
    
    mutating func endTask(at time: Date) {
        addCompletedTask(
            taskCategoryId: ongoingTask!.taskCategoryId,
            taskDescription: ongoingTask!.taskDescription,
            beginTime: ongoingTask!.beginTime,
            endTime: time)
        ongoingTask = nil
    }
}
