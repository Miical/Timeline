//
//  TodoTask.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import Foundation

struct TodoTask: Codable, Identifiable {
    var name: String
    
    /// 任务开始时间，若为全局代办，则为nil
    var beginTime: Date?
    
    /// 任务完成时间，若尚未完成则为nil
    var endTime: Date?
    var id: Int
    
    var isComplete: Bool {
        endTime != nil
    }
    
    mutating func complete(at time: Date) {
        endTime = time
    }
    
    mutating func cancelCompletion() {
        endTime = nil
    }
}

