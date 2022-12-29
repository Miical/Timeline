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
        loadDemoContent()
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
        }
    }
    
    
    // MARK: - 管理记录
    
    /// 按照时间顺序返回指定日期的所有记录
    func allRecord(for date: Date) -> [Record] {
        return timelineModel.allRecord(for: date)
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
    
    // MARK: - 管理任务执行
    
    var ongoingTask: TimelineManager.OngoingTask {
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
