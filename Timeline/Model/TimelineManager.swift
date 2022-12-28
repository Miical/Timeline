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
    
    // MARK: - 记录的增加、修改、删除
    
    mutating func addCompletedTask(taskCategoryName: String, beginTime: Date,  endTime: Date) {
        recordList.append(.completedTask(CompletedTask(
            beginTime: beginTime,
            endTime: endTime,
            taskCategoryName: taskCategoryName,
            id: recordList.count)))
    }
    
    // MARK: - 管理任务执行
    
    // 正在进行的任务，包含任务类别以及任务的开始时间
    typealias OngoingTask = (String, Date)?
    private(set) var ongoingTask: OngoingTask = nil
    
    mutating func startATask(of taskCategory: TaskCategory, at time: Date) {
        assert(ongoingTask == nil, "there is a task in progress")
        ongoingTask = (taskCategory.name, time)
    }
    
    mutating func endTask(at time: Date) {
        addCompletedTask(taskCategoryName: ongoingTask!.0, beginTime: ongoingTask!.1, endTime: time)
        ongoingTask = nil
    }
    
}
