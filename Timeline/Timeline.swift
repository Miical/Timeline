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
        /*
        if let taskCategoryUrl = Timeline.taskCategoryUrl,
           let timelineUrl = Timeline.timelineUrl,
           let localTaskCategoryModel = try? TaskCategoryManager(url: taskCategoryUrl),
           let localTimelineModel = try? TimelineManager(url: timelineUrl) {
            
            taskCategoryModel = localTaskCategoryModel
            timelineModel = localTimelineModel
        } else {
         */
            taskCategoryModel = TaskCategoryManager()
            timelineModel = TimelineManager()
            loadDemoContent()
        // }
    }
    
    func loadDemoContent() {
        taskCategoryModel.addTaskCategory(name: "学习", themeColor: RGBAColor(red: 255, green: 0, blue: 0, alpha: 1), iconSystemName: "book.closed")
        taskCategoryModel.addTaskCategory(name: "运动", themeColor: RGBAColor(red: 255, green: 255, blue: 0, alpha: 1), iconSystemName: "figure.disc.sports")
        taskCategoryModel.addTaskCategory(name: "玩游戏", themeColor: RGBAColor(red: 255, green: 0, blue: 255, alpha: 1), iconSystemName: "gamecontroller")
        taskCategoryModel.addTaskCategory(name: "听音乐", themeColor: RGBAColor(red: 0, green: 0, blue: 255, alpha: 1), iconSystemName: "music.quarternote.3")
        taskCategoryModel.addTaskCategory(name: "学英语", themeColor: RGBAColor(red: 0, green: 255, blue: 255, alpha: 1), iconSystemName: "books.vertical")
        
        for i in 1..<4 {
            timelineModel.addCompletedTask(
                taskCategoryId: taskCategoryList.randomElement()!.id,
                taskDescription: "示例已完成任务 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(i * 10)),
                endTime: Date(timeIntervalSinceNow: TimeInterval(i * 10 + 555)))
        }
        
        for i in 1..<4 {
            timelineModel.addPlannedTask(
                taskCategoryId: taskCategoryList.randomElement()!.id,
                taskDescription: "示例计划任务 \(i)",
                beginTime: Date(timeIntervalSinceNow: TimeInterval(100 + i * 10)),
                endTime: Date(timeIntervalSinceNow: TimeInterval(100 + i * 10 + 20)))
            timelineModel.addPlannedTask(
                taskCategoryId: taskCategoryList.randomElement()!.id,
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
                switch(repeatPlan.task) {
                case .plannedTask(let plannedTask):
                    allRecords.append(Record.plannedTask(PlannedTask(
                        beginTime: connectDateAndTime(date: date, time: plannedTask.beginTime),
                        endTime: connectDateAndTime(date: date, time: plannedTask.endTime),
                        taskCategoryId: plannedTask.taskCategoryId,
                        taskDescription: plannedTask.taskDescription,
                        id: plannedTask.id)))
                case .todoTask(let todoTask):
                    allRecords.append(Record.todoTask(TodoTask(
                        name: todoTask.name,
                        beginTime: connectDateAndTime(date: date, time: todoTask.beginTime!),
                        id: todoTask.id)))
                default:
                    break
                }
            }
        }
        return allRecords.sorted { record1, record2 in
            record1.getBeginTime()! < record2.getBeginTime()! }
    }
    
    /// 删除指定id的记录
    func removeRecord(at idSet: IndexSet) {
        timelineModel.removeRecord(at: idSet)
    }
    
    func canAddCompletedTask(from beginTime: Date, to endTime: Date) -> Bool {
        timelineModel.canAddCompletedTask(from: beginTime, to: endTime)
    }
        
    func addCompletedTask(taskCategoryId: Int, taskDescription: String,
                          beginTime: Date, endTime: Date) {
        timelineModel.addCompletedTask(
            taskCategoryId: taskCategoryId,
            taskDescription: taskDescription,
            beginTime: beginTime,
            endTime: endTime)
    }
    
    func replaceCompletedTask(with newCompletedTask: CompletedTask) {
        timelineModel.replaceCompletedTask(with: newCompletedTask)
    }
    
    func addPlannedTask(taskCategoryId: Int, taskDescription: String,
                        beginTime: Date, endTime: Date, isAvailable: [Bool]? = nil) {
        timelineModel.addPlannedTask(
            taskCategoryId: taskCategoryId,
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
        timelineModel.cancelGlobalCompletion(of: todoTask)
    }
    
    func replaceGlobalTodoTask(with newTodoTask: TodoTask) {
        timelineModel.replaceGlobalTodoTask(with: newTodoTask)
    }
    
    func removeGlobalTodoTask(at indexSet: IndexSet) {
        timelineModel.removeGlobalTodoTask(at: indexSet)
    }
    
    func moveGloblaTodoTask(from offsets: IndexSet, to newOffset: Int) {
        timelineModel.moveGlobalTodoTask(from: offsets, to: newOffset)
    }
    
    // MARK: - 重复计划管理
    
    var allRepeatPlans: [Record] {
        var records: [Record] = []
        for repeatPlan in timelineModel.repeatPlans {
            records.append(repeatPlan.task)
        }
        return records.sorted { record1, record2 in
            record1.getBeginTime()! < record2.getBeginTime()! }
    }
    
    func repeatPlan(with id: Int) -> RepeatPlan {
        timelineModel.repeatPlan(with: id)
    }
    
    func removeRepeatPlan(at idSet: IndexSet) {
        timelineModel.removeRepeatPlan(at: idSet)
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
    
    func taskCategory(id: Int) -> TaskCategory {
        return taskCategoryList.first(where: { $0.id == id })!
    }
    
    func addTaskCategory(_ taskCategory: TaskCategory) {
        taskCategoryModel.addTaskCategory(name: taskCategory.name,
            themeColor: taskCategory.themeColor, iconSystemName: taskCategory.iconSystemName)
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
    
    func canRemove(_ taskCategory: TaskCategory) -> Bool {
        for record in timelineModel.recordList {
            switch(record) {
            case .plannedTask(let plannedTask):
                if plannedTask.taskCategoryId == taskCategory.id {
                    return false
                }
            case .completedTask(let completedTask):
                if completedTask.taskCategoryId == taskCategory.id {
                    return false
                }
            default:
                break
            }
        }
        for repeatPlan in timelineModel.repeatPlans {
            switch(repeatPlan.task) {
            case .plannedTask(let plannedTask):
                if plannedTask.taskCategoryId == taskCategory.id {
                    return false
                }
            default:
                break
            }
        }
        
        return false
    }
    
    // MARK: - 统计
    
    func getStatisticsData(for date: Date) -> [Pie] {
        var taskCategoryTime = Array(repeating: 0, count: taskCategoryList.count)
        
        for record in allRecords(for: date) {
            switch(record) {
            case .completedTask(let completedTask):
                let id = taskCategoryList.index(matching: taskCategory(id: completedTask.taskCategoryId))!
                taskCategoryTime[id] += completedTask.durationInSeconds
            case .plannedTask(let plannedTask):
                let id = taskCategoryList.index(matching: taskCategory(id: plannedTask.taskCategoryId))!
                taskCategoryTime[id] += plannedTask.totalExecutionTimeInSeconds
            default:
                break
            }
        }
        
        let totalTime: CGFloat = CGFloat(taskCategoryTime.reduce(0) { partialResult, time in
            partialResult + time
        })
        
        if totalTime == 0 {
            return []
        } else {
            var statisticsData: [Pie] = []
            for i in taskCategoryTime.indices {
                if taskCategoryTime[i] > 0 {
                    statisticsData.append(Pie(
                        id: i,
                        percent: CGFloat(taskCategoryTime[i]) / totalTime * 100.0,
                        data: taskCategoryTime[i],
                        name: taskCategoryList[i].name,
                        color: taskCategoryList[i].color))
                }
            }
            return statisticsData
        }
    }
}
