//
//  RepeatPlan.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import Foundation

struct RepeatPlan: Codable, Identifiable {
    var task: Record
    var isAvailable = Array(repeating: false, count: 7)
    var id: Int { task.id }
    
    func isAvailableAt(date: Date) -> Bool {
        return isAvailable[theDayOfTheWeek(at: date)]
    }
}
