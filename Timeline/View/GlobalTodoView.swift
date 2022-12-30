//
//  GlobalTodoView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import SwiftUI

struct GlobalTodoView: View {
    @EnvironmentObject var timeline: Timeline
    var body: some View {
        NavigationView {
            List {
                ForEach(timeline.globalTodoTasks) { todoTask in
                    NavigationLink(destination: TodoTaskEditor(todoTask)) {
                        Text("\(todoTask.name)")
                        if todoTask.isComplete {
                            Button("取消") {
                                timeline.cancelGlobalCompletion(of: todoTask)
                            }
                        } else {
                            Button("完成") {
                                timeline.completeGlobalTodoTask(todoTask, at: Date())
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    timeline.removeGlobalTodoTask(at: indexSet)
                }
            }
            .navigationTitle("所有待办")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem { EditButton() }
            }
        }
    }
}
