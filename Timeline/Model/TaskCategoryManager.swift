//
//  TaskCategoryManager.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TaskCategoryManager {
    private(set) var taskCategoryList: [TaskCategory]
    
    init() {
        taskCategoryList = []
        taskCategoryList.append(TaskCategory(
            name: "Game",
            themeColor: RGBAColor(red: 255, green: 0, blue: 0, alpha: 1),
            id: 0))
        taskCategoryList.append(TaskCategory(
            name: "Sport",
            themeColor: RGBAColor(red: 0, green: 255, blue: 0, alpha: 1),
            id: 1))
    }
    
}
