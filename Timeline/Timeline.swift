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
    
    
    
}
