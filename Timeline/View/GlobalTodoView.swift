//
//  GlobalTodoView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/30.
//

import SwiftUI

struct GlobalTodoView: View {
    @EnvironmentObject var timeline: Timeline
    @State private var editMode: EditMode = .inactive
    
    @State private var isPresentEditor = false
    @State private var todoTaskToEdit: TodoTask?
    
    var body: some View {
        ZStack {
            VStack {
                titleBar
                List {
                    ForEach(timeline.globalTodoTasks) { todoTask in
                        GlobalTodoTaskCard(todoTask: todoTask)
                            .onTapGesture {
                                if editMode == .active {
                                    todoTaskToEdit = todoTask
                                    isPresentEditor = true
                                }
                            }
                    }
                    .onDelete { indexSet in
                        timeline.removeGlobalTodoTask(at: indexSet)
                    }
                    .onMove { indexSet, newPosition in
                        timeline.moveGloblaTodoTask(from: indexSet, to: newPosition)
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem { EditButton() }
                }
                .environment(\.editMode, $editMode)
            }
            
            if isPresentEditor {
                GlobalTodoTaskEditor(todoTaskToEdit, isPresent: $isPresentEditor)
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
            
            Text("待办")
                .fontWeight(.medium)
            
            Spacer()
            Button {
                withAnimation {
                    todoTaskToEdit = nil
                    isPresentEditor = true
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }.padding(.trailing, 15.0)
        }
        .padding()
        .background { Color.white }
        
        
    }
}

struct GlobalTodoTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var todoTask: TodoTask
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
            HStack {
                if todoTask.isComplete {
                    Image(systemName: "checkmark.square")
                        .onTapGesture {
                            withAnimation {
                                timeline.cancelGlobalCompletion(of: todoTask)
                            }
                        }
                } else {
                    Image(systemName: "square")
                        .onTapGesture {
                            withAnimation {
                                timeline.completeGlobalTodoTask(todoTask, at: Date())
                            }
                        }
                }
                
                if todoTask.isComplete {
                    Text(todoTask.name)
                        .strikethrough()
                } else {
                    Text(todoTask.name)
                }
                
                Spacer()
                
                if todoTask.isComplete {
                    VStack(alignment: .trailing) {
                        Text("——完成时间")
                        Text(getDateTimeString(of: todoTask.endTime!))
                    }
                    .foregroundColor(.gray)
                    .font(.footnote)
                }
                
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 4)
                    .opacity(0.6)
                    .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35, opacity: 0.8))
                    .padding(8)
            }
            .padding()
        }
    }
}
