//
//  RepeatPlanManager.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/4.
//

import SwiftUI

struct RepeatPlanManagementView: View {
    @EnvironmentObject var timeline: Timeline
    @State private var editMode: EditMode = .inactive
    
    @State var needToAdd = false
    @State var plannedTaskToEdit: PlannedTask?
    @State var todoTaskToEdit: TodoTask?
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    titleBar
                    List {
                        ForEach(timeline.allRepeatPlans) { record in
                            switch(record) {
                                case .plannedTask(let plannedTask):
                                    RepeatPlannedTaskCard(plannedTask: plannedTask)
                                    .onTapGesture {
                                        if editMode == .active {
                                            withAnimation {
                                                needToAdd = false
                                                plannedTaskToEdit = plannedTask
                                            }
                                        }
                                    }
                                case .todoTask(let todoTask):
                                    RepeatTodoTaskCard(todoTask: todoTask)
                                    .onTapGesture {
                                        if editMode == .active {
                                            withAnimation {
                                                needToAdd = false
                                                todoTaskToEdit = todoTask
                                            }
                                        }
                                    }
                                default:
                                    EmptyView()
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                switch timeline.allRepeatPlans[index] {
                                case .plannedTask(let plannedTask):
                                    timeline.removeRepeatPlan(at: plannedTask.attachedRepeatPlanId!)
                                case .todoTask(let todoTask):
                                    timeline.removeRepeatPlan(at: todoTask.attachedRepeatPlanId!)
                                default:
                                    break
                                }
                            }
                        }
                        Spacer(minLength: 100.0)
                    }
                }
                .background(.white)
                .listStyle(.plain)
                .environment(\.editMode, $editMode)
            }
            
            if plannedTaskToEdit != nil {
                PlannedTaskEditor($plannedTaskToEdit, needToAdd: needToAdd)
            } else if todoTaskToEdit != nil {
                TodoTaskEditor($todoTaskToEdit, needToAdd: needToAdd)
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
            
            Text("重复计划管理")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.top, -50)
            
            Spacer()
            
            Menu {
                AnimatedActionButton(title: "新建重复计划任务", action: {
                    needToAdd = true
                    plannedTaskToEdit = PlannedTask(
                        beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "", id: 0)
                })
                AnimatedActionButton(title: "新建重复待办", action: {
                    needToAdd = true
                    todoTaskToEdit = TodoTask(name: "", id: 0)})
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }.padding(.trailing, 15.0)
            
            
            
        }
        .padding(.horizontal)
        .background { Color.white }
    }
}

struct RepeatPlannedTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var plannedTask: PlannedTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
            HStack {
                HStack {
                    timeline.taskCategory(id: plannedTask.taskCategoryId).icon
                        .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35))
                    Text(timeline.taskCategory(id: plannedTask.taskCategoryId).name)
                        .foregroundColor(.gray)
                }
                .font(.footnote)
                .frame(minWidth: 80, maxWidth: 80)
                Spacer()
                
                VStack (alignment: .leading) {
                    Text("\(getTimeString(of: plannedTask.beginTime)) - \(getTimeString(of: plannedTask.endTime))")
                        .font(.headline)
                        .padding(.vertical, 2)
                    
                    HStack{
                        Image(systemName: "list.dash.header.rectangle")
                        Text(plannedTask.taskDescription)
                    }
                    .padding(.leading, 10)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    
                    HStack{
                        Image(systemName: "clock")
                        Text("计划时长：\(timeStringFromSeconds(plannedTask.durationInSeconds))")
                    }
                    .padding(.leading, 12)
                    .padding(.vertical, 1)
                    .font(.footnote)
                    .foregroundColor(.gray)
                }
                
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 4)
                    .opacity(0.4)
                    .foregroundColor(timeline.taskCategory(id: plannedTask.taskCategoryId).color)
                    .padding(8)
            }
            .padding()
        }
    }
}

struct RepeatTodoTaskCard: View {
    @EnvironmentObject var timeline: Timeline
    var todoTask: TodoTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TimelineCardify.CardConstants.cornerRadius)
                .foregroundColor(.white)
            HStack {
                Text(todoTask.name)
                    .font(.system(size: 15))
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 4)
                    .opacity(0.4)
                    .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35, opacity: 0.8))
                    .padding(8)
            }
            .padding()
        }
    }

}

