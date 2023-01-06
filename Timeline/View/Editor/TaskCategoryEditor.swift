//
//  TaskCategoryEditor.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/28.
//

import SwiftUI

struct TaskCategoryEditor: View {
    @EnvironmentObject var timeline: Timeline
    @State var taskCategory: TaskCategory
    @Binding var isPresent: Bool
    
    var needCreateTaskCategory: Bool
    
    // taskCategoryToEdit 为 nil 时保存，将会新建一个任务分类
    init(_ taskCategoryToEdit: TaskCategory?, isPresent: Binding<Bool>) {
        self._isPresent = isPresent
        if let taskCategoryToEdit = taskCategoryToEdit {
            taskCategory = taskCategoryToEdit
            needCreateTaskCategory = false
        } else {
            taskCategory = TaskCategory(name: "", themeColor: RGBAColor(color: Color(.white)), iconSystemName: "book", id: 0)
            needCreateTaskCategory = true
        }
    }
    
    var body: some View {
        VStack {
            TextEditor(name: "名称", text: $taskCategory.name, wordsLimit: 10)
            ThemeColorPicker(color: $taskCategory.themeColor)
            SystemIconPicker(iconName: $taskCategory.iconSystemName)
        }
        .turnToEditor(isPresent: $isPresent, title: "\(needCreateTaskCategory ? "新建" : "编辑")任务分类", onSave: {
            if needCreateTaskCategory {
                timeline.addTaskCategory(taskCategory)
            } else {
                timeline.replaceTaskCategory(with: taskCategory)
            }
        })
    }
}
