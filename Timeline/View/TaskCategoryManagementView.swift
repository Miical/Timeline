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
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack {
                titleBar
                List {
                    ForEach(timeline.taskCategoryList) { taskCategory in
                        taskCategoryCard(taskCategory: taskCategory)
                    }
                    .onDelete { indexSet in
                        timeline.removeTaskCategory(at: indexSet)
                    }
                    .onMove { indexSet, newOffset in
                        timeline.moveTaskCategory(from: indexSet, to: newOffset)
                    }
                }
                .background(.white)
                .environment(\.editMode, $editMode)
            }
        }
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
