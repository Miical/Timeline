//
//  Record.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

enum Record: Codable, Identifiable {
    case completedTask(CompletedTask)
    case plannedTask(PlannedTask)
    case todoTask(TodoTask)
    
    func getBeginTime() -> Date? {
        switch self {
        case let .completedTask(task):
            return task.beginTime
        case let .plannedTask(task):
            return task.beginTime
        case let .todoTask(task):
            return task.beginTime
        }
    }
    
    func getEndTime() -> Date? {
        switch self {
        case let .completedTask(task):
            return task.endTime
        case let .plannedTask(task):
            return task.endTime
        default:
            return nil
        }
    }
    
    var attachedRepeatPlan: Int? {
        switch self {
        case let .plannedTask(task):
            return task.attachedRepeatPlanId
        case let .todoTask(task):
            return task.attachedRepeatPlanId
        default:
            return nil
        }
    }
    
    var id: Int {
        switch self {
        case let .completedTask(task):
            return task.id
        case let .plannedTask(task):
            return task.id
        case let .todoTask(task):
            return task.id
        }
    }
}
