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
    
    func getTime() -> Date? {
        switch self {
        case let .completedTask(task):
            return task.beginTime
        case let .plannedTask(task):
            return task.beginTime
        }
    }
    
    var id: Int {
        switch self {
        case let .completedTask(task):
            return task.id
        case let .plannedTask(task):
            return task.id
        }
    }
}
