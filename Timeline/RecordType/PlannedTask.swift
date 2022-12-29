//
//  PlannedTask.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct PlannedTask: Recordable {
    var beginTime: Date
    var endTime: Date
    var taskCategoryName: String
    var taskDescription: String
    var isOver = false
    var id: Int
    
    /// 存储任务实际执行的时间节点，依次代表：开始、暂停、继续、...、暂停、继续、结束
    var taskExecution: [Date] = []
    
    /// 计算任务实际执行时间
    /// 若任务未开始则返回0，
    /// 若任务还在进行则返回任务执行到目前的秒数，
    /// 若任务已结束则返回任务执行的秒数。
    var totalExecutionTimeInSeconds: Int {
        var totalSeconds = 0, i = 1
        while i < taskExecution.count {
            totalSeconds += intervalSeconds(between: taskExecution[i - 1], and: taskExecution[i])
            i += 2
        }
        if taskExecution.count % 2 == 1 {
            totalSeconds += intervalSeconds(between: taskExecution.last!, and: Date())
        }
        return totalSeconds
    }
    
    /// 任务是否正在执行
    var isExecuting: Bool {
        taskExecution.count % 2 == 1
    }
    
    /// 任务是否已被执行
    var isExecuted: Bool {
        taskExecution.count > 0
    }
    
    /// 切换任务的执行状态
    /// 如果任务目前正在执行，则停止执行，否则继续执行。
    mutating func changeState(at time: Date) {
        taskExecution.append(time)
    }
}
