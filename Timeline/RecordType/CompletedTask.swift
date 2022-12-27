//
//  CompletedTask.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct CompletedTask: Codable, Identifiable {
    var beginTime: Date
    var durationInSeconds: Int
    var taskCategory: TaskCategory
    var id: Int
}
