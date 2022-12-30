//
//  Timeline.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

class Timeline: ObservableObject {
    @Published private var taskCategoryModel: TaskCategoryManager {
        didSet { save() }
    }
    @Published private var timelineModel: TimelineManager {
        didSet { save() }
    }
    
    static let taskCategoryFilename = "Timeline.taskCategory"
    static let timelineFilename = "Timeline.timeline"
    static var taskCategoryUrl: URL? {
        let timelineDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return timelineDirectory?.appendingPathComponent(taskCategoryFilename)
    }
    static var timelineUrl: URL? {
        let timelineDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return timelineDirectory?.appendingPathComponent(timelineFilename)
    }
    
    private func save() {
        if let taskCategoryUrl = Timeline.taskCategoryUrl,
           let timelineUrl = Timeline.timelineUrl {
            save(to: taskCategoryUrl, and: timelineUrl)
        }
    }
    
    private func save(to taskCategoryUrl: URL, and timelineUrl: URL) {
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let taskCategoryData: Data = try taskCategoryModel.json()
            try taskCategoryData.write(to: taskCategoryUrl)
            print("\(taskCategoryData)")
            let timelineData: Data = try timelineModel.json()
            try timelineData.write(to: timelineUrl)
            print("\(thisfunction) success!")
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) couldn't encode Timeline as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisfunction) error = \(error)")
        }
    }
    
    init() {
        if let taskCategoryUrl = Timeline.taskCategoryUrl,
           let timelineUrl = Timeline.timelineUrl,
           let localTaskCategoryModel = try? TaskCategoryManager(url: taskCategoryUrl),
           let localTimelineModel = try? TimelineManager(url: timelineUrl) {
            
            taskCategoryModel = localTaskCategoryModel
            timelineModel = localTimelineModel
        } else {
            taskCategoryModel = TaskCategoryManager()
            timelineModel = TimelineManager()
            loadDemoContent()
        }
    }
    
    func loadDemoContent() {
        taskCategoryModel.addTaskCategory(name: "学习", themeColor: RGBAColor(red: 255, green: 0, blue: 0, alpha: 1))
        taskCategoryModel.addTaskCategory(name: "运动", themeColor: RGBAColor(red: 255, green: 255, blue: 0, alpha: 1))
        taskCategoryModel.addTaskCategory(name: "玩游戏", themeColor: RGBAColor(red: 255, green: 0, blue: 255, alpha: 1))
        taskCategoryModel.addTaskCategory(name: "听音乐", themeColor: RGBAColor(red: 0, green: 0, blue: 255, alpha: 1))
        taskCategoryModel.addTaskCategory(name: "学英语", themeColor: RGBAColor(red: 0, green: 255, blue: 255, alpha: 1))
        
        for i in 1..<4 {
            timelineModel.addCompletedTask(
                taskCategoryName: taskCategoryList.randomElement()!.name,
                taskDescription: "示例已完成任务 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(i * 10)),
                endTime: Date(timeIntervalSinceNow: TimeInterval(i * 10 + 5)))
        }
        
        for i in 1..<4 {
            timelineModel.addPlannedTask(
                taskCategoryName: taskCategoryList.randomElement()!.name,
                taskDescription: "示例计划任务 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(100 + i * 10)),
                endTime: Date(timeIntervalSinceNow: TimeInterval(100 + i * 10 + 20)))
            timelineModel.addPlannedTask(
                taskCategoryName: taskCategoryList.randomElement()!.name,
                taskDescription: "示例重复计划任务 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(300 + i * 10)),
                endTime: Date(timeIntervalSinceNow: TimeInterval(300 + i * 10 + 20)),
                isAvailable: Array(repeating: true, count: 7))
        }
        
        for i in 1..<4 {
            timelineModel.addTodoTask(
                taskName: "示例代办 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(200 + i * 10)))
            timelineModel.addTodoTask(
                taskName: "示例重复代办 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(400 + i * 10)),
                isAvailable: Array(repeating: true, count: 7))
        }
        
        for i in 1..<4 {
            timelineModel.addGlobalTodoTask(taskName: "示例全局代办 \(i)")
        }
    }
    
    
    // MARK: - 管理记录
    
    /// 按照时间顺序返回指定日期的所有记录
    func allRecords(for date: Date) -> [Record] {
        var allRecords = timelineModel.allRecord(for: date)
        for repeatPlan in timelineModel.allRepeatPlans(for: date) {
            if !allRecords.contains(where: { $0.attachedRepeatPlan == repeatPlan.id }) {
                allRecords.append(repeatPlan.task)
            }
        }
        return allRecords.sorted { record1, record2 in
            record1.getBeginTime()! < record2.getBeginTime()! }
    }
    
    /// 删除指定id的记录
    func removeRecord(at idSet: IndexSet) {
        timelineModel.removeRecord(at: idSet)
    }
    
    func addCompletedTask(taskCategoryName: String, taskDescription: String,
                          beginTime: Date, endTime: Date) {
        timelineModel.addCompletedTask(
            taskCategoryName: taskCategoryName,
            taskDescription: taskDescription,
            beginTime: beginTime,
            endTime: endTime)
    }
    
    func replaceCompletedTask(with newCompletedTask: CompletedTask) {
        timelineModel.replaceCompletedTask(with: newCompletedTask)
    }
    
    func addPlannedTask(taskCategoryName: String, taskDescription: String,
                        beginTime: Date, endTime: Date, isAvailable: [Bool]? = nil) {
        timelineModel.addPlannedTask(
            taskCategoryName: taskCategoryName,
            taskDescription: taskDescription,
            beginTime: beginTime,
            endTime: endTime,
            isAvailable: isAvailable)
    }
    
    func modifyPlannedTask(with plannedTask: PlannedTask) {
        timelineModel.modifyPlannedTask(with: plannedTask)
    }
    
    
    func addTodoTask(taskName: String, beginTime: Date, isAvailable: [Bool]? = nil) {
        timelineModel.addTodoTask(
            taskName: taskName, beginTime: beginTime, isAvailable: isAvailable)
    }
    
    func completeTodoTask(_ todoTask: TodoTask, at time: Date) {
        timelineModel.completeTodoTask(todoTask, at: time)
    }
    
    func cancelCompletion(of todoTask: TodoTask) {
        timelineModel.cancelCompletion(of: todoTask)
    }
    
    func replaceTodoTask(with newTodoTask: TodoTask) {
        timelineModel.replaceTodoTask(with: newTodoTask)
    }
    
    var globalTodoTasks: [TodoTask] {
        timelineModel.globalTodoTasks
    }
    
    func addGlobalTodoTask(taskName: String) {
        timelineModel.addGlobalTodoTask(taskName: taskName)
    }
    
    func completeGlobalTodoTask(_ todoTask: TodoTask, at time: Date) {
        timelineModel.completeGlobalTodoTask(todoTask, at: time)
    }
    
    func cancelGlobalCompletion(of todoTask: TodoTask) {
        timelineModel.cancelCompletion(of: todoTask)
    }
    
    func replaceGlobalTodoTask(with newTodoTask: TodoTask) {
        timelineModel.replaceGlobalTodoTask(with: newTodoTask)
    }
    
    func removeGlobalTodoTask(at idSet: IndexSet) {
        timelineModel.removeGlobalTodoTask(at: idSet)
    }
    
    func removeRepeatPlan(at idSet: IndexSet) {
        timelineModel.removeRecord(at: idSet)
    }
    
    func replaceRepeatPlan(with newNepeatPlan: RepeatPlan) {
        timelineModel.replaceRepeatPlan(with: newNepeatPlan)
    }
    
    // MARK: - 管理任务执行
    
    var ongoingTask: TimelineManager.OngoingTask? {
        return timelineModel.ongoingTask
    }
    
    func startATask(of taskCategory: TaskCategory, with taskDescripion: String, at time: Date) {
        timelineModel.startATask(of: taskCategory, with: taskDescripion, at: time)
    }
    
    func endTask(at time: Date) {
        timelineModel.endTask(at: time)
    }
    
    // MARK: - 管理任务类别
    
    var taskCategoryList: [TaskCategory] {
        taskCategoryModel.taskCategoryList
    }
    
    func getThemeColor(of taskCategoryName: String) -> Color {
        Color(rgbaColor: taskCategoryList
            .filter({ $0.id == taskCategoryName })
            .first! .themeColor)
    }
    
    func addTaskCategory(_ taskCategory: TaskCategory) {
        taskCategoryModel.addTaskCategory(name: taskCategory.name,
                                          themeColor: taskCategory.themeColor)
    }
    
    func removeTaskCategory(at offsets: IndexSet) {
        taskCategoryModel.removeTaskCategory(at: offsets)
    }
    
    func moveTaskCategory(from offsets: IndexSet, to newOffset: Int) {
        taskCategoryModel.moveTaskCategory(from: offsets, to: newOffset)
    }
    
    // 将列表中与 newTaskCategory 具有相同id的元素替换为 newTaskCategory
    func replaceTaskCategory(with newTaskCategory: TaskCategory) {
        taskCategoryModel.replaceTaskCategory(with: newTaskCategory)
    }
}
