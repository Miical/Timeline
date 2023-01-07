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
            loadDefaultTaskCategories()
            loadDemoContent()
        }
    }
    
    func loadDefaultTaskCategories() {
        taskCategoryModel.addTaskCategory(
            name: "吃饭",
            themeColor: RGBAColor(red: 0.96, green: 0.80, blue: 0.35, alpha: 1),
            iconSystemName: "fork.knife")
        taskCategoryModel.addTaskCategory(
            name: "学习",
            themeColor: RGBAColor(red: 0.64, green: 0.82, blue: 0.43, alpha: 1),
            iconSystemName: "book.closed")
        taskCategoryModel.addTaskCategory(
            name: "工作",
            themeColor: RGBAColor(red: 0.47, green: 0.83, blue: 0.97, alpha: 1),
            iconSystemName: "bag")
        taskCategoryModel.addTaskCategory(
            name: "运动",
            themeColor: RGBAColor(red: 0.93, green: 0.45, blue: 0.18, alpha: 1),
            iconSystemName: "figure.disc.sports")
        taskCategoryModel.addTaskCategory(
            name: "休息",
            themeColor: RGBAColor(red: 0.1, green: 0.25, blue: 0.64, alpha: 1),
            iconSystemName: "bed.double")
        taskCategoryModel.addTaskCategory(
            name: "路上",
            themeColor: RGBAColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 1),
            iconSystemName: "figure.walk")
        taskCategoryModel.addTaskCategory(
            name: "娱乐",
            themeColor: RGBAColor(red: 0.92, green: 0.30, blue: 0.24, alpha: 1),
            iconSystemName: "gamecontroller")
        taskCategoryModel.addTaskCategory(
            name: "听音乐", themeColor:
                RGBAColor(red: 0.87, green: 0.83, blue: 0.27, alpha: 1),
            iconSystemName: "music.quarternote.3")
    }
    
    func loadDemoContent() {
        var date = TheDayBefore(numOfDays: 10, date: Date())
        let currentDate = Date()
        while date <= TheDayAfter(numOfDays: 10, since: currentDate) {
            let startTime = getTheStartOf(date: date)
            let completedTaskEndTime = isSameDay(date, currentDate) ? currentDate : getTheEndOf(date: date)
            let endTime = getTheEndOf(date: date)
            
            if startTime < currentDate {
                randomTask(between: startTime, and: completedTaskEndTime, type: 0, taskNumber: 10)
                randomTask(between: startTime, and: completedTaskEndTime, type: 2, taskNumber: 2)
            }
            randomTask(between: startTime, and: endTime, type: 1, taskNumber: 3)
            randomTask(between: startTime, and: endTime, type: 3, taskNumber: 4)
            randomTask(between: startTime, and: endTime, type: 4, taskNumber: 2)
            
            date = TheNextDay(of: date)
        }
        
        randomGlobalTodoTasks(taskNumber: 10)
    }
    
    var taskId = 0
    func getTaskId() -> Int {
        taskId += 1
        return taskId
    }
    func randomTask(between beginTime: Date, and endTime: Date, type: Int, taskNumber: Int) {
        let totalSeconds = intervalSeconds(between: beginTime, and: endTime)
        var timeNodes: [Int] = []
        
        for _ in 0..<taskNumber*2 {
            timeNodes.append(Int(arc4random_uniform(UInt32(totalSeconds))))
        }
        timeNodes.sort()
        
        var i = 0
        while i < timeNodes.count {
            let taskBeginTime = Date(timeInterval: TimeInterval(timeNodes[i]), since: beginTime)
            let taskEndTime = Date(timeInterval: TimeInterval(timeNodes[i + 1]), since: beginTime)
            
            switch(type) {
            case 0:
                timelineModel.addCompletedTask(
                    taskCategoryId: taskCategoryList.randomElement()!.id,
                    taskDescription: "示例已完成任务 \(getTaskId())",
                    beginTime: taskBeginTime, endTime: taskEndTime)
            case 1:
                timelineModel.addPlannedTask(
                    taskCategoryId: taskCategoryList.randomElement()!.id,
                    taskDescription: "示例计划任务 \(getTaskId())",
                    beginTime: taskBeginTime, endTime: taskEndTime)
            case 2:
                timelineModel.addPlannedTask(
                    taskCategoryId: taskCategoryList.randomElement()!.id,
                    taskDescription: "示例重复计划任务 \(getTaskId())",
                    beginTime: taskBeginTime, endTime: taskEndTime,
                    isAvailable: randomIsAvailable())
            case 3:
                timelineModel.addTodoTask(
                    taskName: "示例代办 \(getTaskId())",
                    beginTime: taskBeginTime)
            case 4:
                timelineModel.addTodoTask(
                    taskName: "示例重复代办 \(getTaskId())",
                    beginTime: taskBeginTime,
                    isAvailable: randomIsAvailable())
            default:
                break
            }
            i += 2
        }
    }
    
    func randomGlobalTodoTasks(taskNumber: Int) {
        for i in 0..<taskNumber {
            timelineModel.addGlobalTodoTask(taskName: "示例全局代办 \(i)")
        }
    }
    
    // MARK: - 管理记录
    
    /// 按照时间顺序返回指定日期的所有记录
    func allRecords(for date: Date) -> [Record] {
        var allRecords = timelineModel.allRecord(for: date)
        for repeatPlan in timelineModel.allRepeatPlans(for: date) {
            if getTheStartOf(date: repeatPlan.task.getBeginTime()!) < date
                && !allRecords.contains(where: { $0.attachedRepeatPlan == repeatPlan.id }) {
                switch(repeatPlan.task) {
                case .plannedTask(let plannedTask):
                    allRecords.append(Record.plannedTask(PlannedTask(
                        beginTime: connectDateAndTime(date: date, time: plannedTask.beginTime),
                        endTime: connectDateAndTime(date: date, time: plannedTask.endTime),
                        taskCategoryId: plannedTask.taskCategoryId,
                        taskDescription: plannedTask.taskDescription,
                        id: plannedTask.id,
                        attachedRepeatPlanId: plannedTask.id
                    )))
                case .todoTask(let todoTask):
                    allRecords.append(Record.todoTask(TodoTask(
                        name: todoTask.name,
                        beginTime: connectDateAndTime(date: date, time: todoTask.beginTime!),
                        id: todoTask.id,
                        attachedRepeatPlanId: todoTask.id
                    )))
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
    
    func removeRepeatPlan(at id: Int) {
        timelineModel.removeRepeatPlan(at: id)
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
