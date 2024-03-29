//
//  TaskCategoryManagementView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TaskCategoryManagementView: View {
    @EnvironmentObject var timeline: Timeline
    @State private var editMode: EditMode = .inactive
    
    @State private var isPresentEditor = false
    @State private var taskCategoryToEdit: TaskCategory?
    
    @State private var isPresentAlert = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    titleBar
                    List {
                        ForEach(timeline.taskCategoryList) { taskCategory in
                            taskCategoryCard(taskCategory: taskCategory)
                                .onTapGesture {
                                    if editMode == .active {
                                        withAnimation {
                                            taskCategoryToEdit = taskCategory
                                            isPresentEditor = true
                                        }
                                    }
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                if timeline.canRemove(timeline.taskCategoryList[index]) {
                                    timeline.removeTaskCategory(at: indexSet)
                                } else {
                                    isPresentAlert = true
                                }
                            }
                        }
                        .onMove { indexSet, newOffset in
                            timeline.moveTaskCategory(from: indexSet, to: newOffset)
                        }
                    }
                    .background(.white)
                    .environment(\.editMode, $editMode)
                }
            }
            if isPresentEditor {
                TaskCategoryEditor(taskCategoryToEdit, isPresent: $isPresentEditor)
            }
        }
        .alert("无法删除任务分类", isPresented: $isPresentAlert, actions: {}, message: { Text("有现有的任务记录或计划任务使用了该任务分类")})
    }
    
    var titleBar: some View {
        HStack {
            Button(action: {
                withAnimation {
                    if editMode == .active { editMode = .inactive }
                    else { editMode = .active }
                }
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.black)
            }.padding(.leading, 15.0)
            Spacer()
            
            Text("任务分类管理")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.top, -50)
            
            Spacer()
            Button {
                withAnimation {
                    taskCategoryToEdit = nil
                    isPresentEditor = true
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }.padding(.trailing, 15.0)
        }
        .padding(.horizontal)
        .background { Color.white }
    }
    
    func taskCategoryCard(taskCategory: TaskCategory) -> some View {
        HStack() {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(taskCategory.color.opacity(0.5))
                .frame(width: 5, height: 30)
                .padding(.horizontal)
            Text(taskCategory.name)
            Spacer()
            taskCategory.icon
                .padding()
        }
    }
}

struct TaskCategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCategoryManagementView()
            .environmentObject(Timeline())
    }
}
