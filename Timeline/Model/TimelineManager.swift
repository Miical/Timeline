//
//  TimelineManager.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TimelineManager {
    var recordList: [Record]
    
    init() {
        recordList = []
        recordList.append(
            .completedTask(CompletedTask(
                beginTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: 12, minute: 0, second: 0))!,
                durationInSeconds: 1234,
                taskCategory: TaskCategory(name: "Study", themeColor: RGBAColor(red: 255, green: 0, blue: 0, alpha: 1), id: 0),
                id: 0)))
        
        recordList.append(
            .plannedTask(PlannedTask(
                beginTime:  Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 27, hour: 12, minute: 20, second: 0))!,
                durationInSeconds: 2333,
                taskCategory: TaskCategory(name: "Sport", themeColor: RGBAColor(red: 0, green: 255, blue: 0, alpha: 1), id: 1),
                id: 1)))
    }
    
    
    func allRecord(for date: Date) -> [Record] {
        return recordList
            .filter { Calendar.current.isDate(date, inSameDayAs: $0.getTime()!) }
            .sorted { record1, record2 in record1.getTime()! > record2.getTime()! }
    }
    
    
}
