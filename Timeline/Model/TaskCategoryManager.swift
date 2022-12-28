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
    }
    
    mutating func addTaskCategory(name: String, themeColor: RGBAColor) {
        taskCategoryList.append(TaskCategory(name: name, themeColor: themeColor))
    }
    
    mutating func removeTaskCategory(at offsets: IndexSet) {
        taskCategoryList.remove(atOffsets: offsets)
    }
    
    mutating func moveTaskCategory(from offsets: IndexSet, to newOffset: Int) {
        taskCategoryList.move(fromOffsets: offsets, toOffset: newOffset)
    }
    
    // 将列表中与 newTaskCategory 具有相同id的元素替换为 newTaskCategory
    mutating func replaceTaskCategory(with newTaskCategory: TaskCategory) {
        taskCategoryList[newTaskCategory] = newTaskCategory
    }
    
}
