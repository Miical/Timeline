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
    
    var needCreateTaskCategory: Bool
    
    // taskCategoryToEdit 为 nil 时保存，将会新建一个任务分类
    init(_ taskCategoryToEdit: TaskCategory?) {
        if let taskCategoryToEdit {
            taskCategory = taskCategoryToEdit
            needCreateTaskCategory = false
        } else {
            taskCategory = TaskCategory(name: "", themeColor: RGBAColor(color: Color(.white)), iconSystemName: "", id: 0)
            needCreateTaskCategory = true
        }
    }
    
    var body: some View {
        VStack {
            Form {
                nameSection
                changeColorSection
            }
            Button("保存") {
                if needCreateTaskCategory {
                    timeline.addTaskCategory(taskCategory)
                } else {
                    timeline.replaceTaskCategory(with: taskCategory)
                }
                
            }
        }
    }
    
    var nameSection: some View {
        Section(header: Text("名称")) {
            TextField("名称", text: $taskCategory.name)
        }
    }
    
    var changeColorSection: some View {
        Section(header: Text("主题色")) {
            ColorPicker(selection: Binding(
            get: {
                Color(rgbaColor: taskCategory.themeColor)
            },
            set: {
                taskCategory.themeColor = RGBAColor(color: $0)
            })){}
        }
    }

}

struct TaskCategoryEditor_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        TaskCategoryEditor(timeline.taskCategoryList.randomElement()!)
            .environmentObject(timeline)
    }
}
