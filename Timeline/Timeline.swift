//
//  Timeline.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

class Timeline: ObservableObject {
    @Published private var taskCategoryModel: TaskCategoryManager
    @Published private var timelineModel: TimelineManager
    
    init() {
        taskCategoryModel = TaskCategoryManager()
        timelineModel = TimelineManager()
    }
    
    // 按照时间顺序返回指定日期的所有记录
    func allRecord(for date: Date) -> [Record] {
        return timelineModel.allRecord(for: date)
    }
    
    // MARK: - 管理任务执行
    
    var ongoingTask: TimelineManager.OngoingTask {
        return timelineModel.ongoingTask
    }
    
    func startATask(of taskCategory: TaskCategory, at time: Date) {
        timelineModel.startATask(of: taskCategory, at: time)
    }
    
    func endTask(at time: Date) {
        timelineModel.endTask(at: time)
    }
    
    // MARK: - 管理任务类别
    
    var taskCategoryList: [TaskCategory] {
        taskCategoryModel.taskCategoryList
    }
    
    func removeTaskCategory(at offsets: IndexSet) {
        taskCategoryModel.removeTaskCategory(at: offsets)
    }
    
    func moveTaskCategory(from offsets: IndexSet, to newOffset: Int) {
        taskCategoryModel.moveTaskCategory(from: offsets, to: newOffset)
    }
    
}
