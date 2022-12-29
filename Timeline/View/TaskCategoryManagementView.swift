//
//  TaskCategoryManagementView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TaskCategoryManagementView: View {
    @EnvironmentObject var timeline: Timeline
    @State var newCategoryEditor = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(timeline.taskCategoryList) { taskCategory in
                    NavigationLink(destination: TaskCategoryEditor(taskCategory)) {
                        HStack() {
                            Text(taskCategory.name)
                            Spacer()
                            Circle().frame(width: 10).foregroundColor(Color(rgbaColor: taskCategory.themeColor))
                        }
                    }
                }
                .onDelete { indexSet in
                    timeline.removeTaskCategory(at: indexSet)
                }
                .onMove { indexSet, newOffset in
                    timeline.moveTaskCategory(from: indexSet, to: newOffset)
                }
            }
            .navigationTitle("管理任务类别")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem { Button("新建") {
                    newCategoryEditor = true
                }}
            }
            .popover(isPresented: $newCategoryEditor, content: {TaskCategoryEditor(nil)})
        }
    }
}

struct TaskCategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCategoryManagementView()
            .environmentObject(Timeline())
    }
}
