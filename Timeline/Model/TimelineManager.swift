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
        for h in 1..<12 {
            recordList.append(
                .completedTask(CompletedTask(
                    beginTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: h, minute: 0, second: 0))!,
                    endTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: h, minute: 30, second: 0))!,
                    taskCategory: TaskCategory(name: "Study", themeColor: RGBAColor(red: 255, green: 0, blue: 0, alpha: 1), id: 0),
                    id: h)))
        }
        
        recordList.append(
            .plannedTask(PlannedTask(
                beginTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: 12, minute: 20, second: 0))!,
                endTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: 12, minute: 50, second: 0))!,
                taskCategory: TaskCategory(name: "Sport", themeColor: RGBAColor(red: 0, green: 255, blue: 0, alpha: 1), id: 1),
                id: 0)))
    }
    
    
    func allRecord(for date: Date) -> [Record] {
        return recordList
            .filter { Calendar.current.isDate(date, inSameDayAs: $0.getBeginTime()!) }
            .sorted { record1, record2 in record1.getBeginTime()! < record2.getBeginTime()! }
    }
    
    // MARK: - 记录的增加、修改、删除
    
    mutating func addCompletedTask(taskCategory: TaskCategory, beginTime: Date,  endTime: Date) {
        recordList.append(.completedTask(CompletedTask(
            beginTime: beginTime,
            endTime: endTime,
            taskCategory: taskCategory,
            id: recordList.count)))
    }
    
    // MARK: - 管理任务执行
    
    // 正在进行的任务，包含任务类别以及任务的开始时间
    private var ongoingTask: (TaskCategory, Date)?
    
    mutating func startATask(of taskCategory: TaskCategory, at time: Date) {
        assert(ongoingTask == nil, "there is a task in progress")
        ongoingTask = (taskCategory, time)
    }
    
    mutating func endTask(at time: Date) {
        addCompletedTask(taskCategory: ongoingTask!.0, beginTime: ongoingTask!.1, endTime: time)
        ongoingTask = nil
    }
    
}
