//
//  TaskCategoryManager.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TaskCategoryManager: Codable {
    private(set) var taskCategoryList: [TaskCategory] = []
    
    init() {}
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(TaskCategoryManager.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try TaskCategoryManager(json: data)
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
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
