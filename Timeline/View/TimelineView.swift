//
//  TimelineView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var currentTab: Tab
    @Binding var attachedPlannedTask: PlannedTask?
    @State var completedTaskEditor = false
    @State var plannedTaskToExecute: PlannedTask?
    
    @State var needToAdd = false
    @State var completedTaskToEdit: CompletedTask?
    @State var plannedTaskToEdit: PlannedTask?
    @State var todoTaskToEdit: TodoTask?
    
    @Binding var selectedDate: Date
    @Binding var isPresentSideBar: Bool
    
    var body: some View {
        ZStack {
            VStack {
                titleBar
                Spacer(minLength: 0)
                timelineBody
            }
            
            if completedTaskToEdit != nil {
                CompletedTaskEditor($completedTaskToEdit, needToAdd: needToAdd)
            } else if plannedTaskToEdit != nil {
                PlannedTaskEditor($plannedTaskToEdit, needToAdd: needToAdd)
            } else if todoTaskToEdit != nil {
                TodoTaskEditor($todoTaskToEdit, needToAdd: needToAdd)
            }
        }
        .dateSideBar(isPresent: $isPresentSideBar,date: $selectedDate)
    }
    
    
    var titleBar: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        isPresentSideBar = true
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.black)
                }.padding(.leading, 15.0)
                
                Spacer(minLength: 0)
                
                Label("Timeline", systemImage: "calendar.day.timeline.leading")
                    .font(.custom("AvenirNextCondensed-DemiBold", size: 18))
                
                Spacer(minLength: 0)
                
                Menu {
                    AnimatedActionButton(title: "新建已完成任务", action: {
                        needToAdd = true
                        completedTaskToEdit = CompletedTask(
                            beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "", id: 0)
                    })
                    AnimatedActionButton(title: "新建计划任务", action: {
                        needToAdd = true
                        plannedTaskToEdit = PlannedTask(
                            beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "", id: 0)
                    })
                    AnimatedActionButton(title: "新建待办", action: {
                        needToAdd = true
                        todoTaskToEdit = TodoTask(name: "", id: 0)})
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }.padding(.trailing, 15.0)
            }
            .padding([.top, .horizontal])
            Divider()
            
            HStack {
                Image(systemName: "calendar")
                Text(getDateString(of: selectedDate))
                Spacer()
            }
            .font(.footnote)
            .padding(.horizontal)
            .foregroundColor(.gray)
            .frame(height: 10.0)
            
            Divider()
                .opacity(0.5)
        }
        .background { Color.white }
    }
    
    var timelineBody: some View {
        VStack {
            ScrollView {
                ForEach(timeline.allRecords(for: selectedDate)) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        completedTaskItem(completedTask: completedTask)
                    case .plannedTask(let plannedTask):
                        plannedTaskItem(plannedTask: plannedTask)
                    case .todoTask(let todoTask):
                        todoTaskItem(todoTask: todoTask)
                    }
                }
                Spacer(minLength: 100.0)
            }
        }
    }
    
    func completedTaskItem(completedTask: CompletedTask) -> some View {
        CompletedTaskCard(completedTask: completedTask)
            .contextMenu {
                AnimatedActionButton(title: "编辑", systemImage: "square.and.pencil") {
                    needToAdd = false
                    completedTaskToEdit = completedTask
                }
                AnimatedActionButton(title: "删除", systemImage: "xmark.square") {
                    timeline.removeRecord(at: IndexSet(integer: completedTask.id))
                }
            }
            .timelineCardify(
                color: timeline.taskCategory(id: completedTask.taskCategoryId).color,
                time: completedTask.beginTime)
    }
    
    func plannedTaskItem(plannedTask: PlannedTask) -> some View {
        PlannedTaskCard(plannedTask: plannedTask)
            .contextMenu {
                if !plannedTask.isExecuted {
                    AnimatedActionButton(title: "执行计划", systemImage: "hourglass.bottomhalf.filled") {
                        attachedPlannedTask = plannedTask
                        currentTab = .timing
                    }
                }
                AnimatedActionButton(title: "编辑", systemImage: "square.and.pencil") {
                    needToAdd = false
                    plannedTaskToEdit = plannedTask}
                AnimatedActionButton(
                    title: plannedTask.attachedRepeatPlanId == nil ? "删除" : "删除重复计划任务",
                    systemImage: "xmark.square") {
                    if (plannedTask.attachedRepeatPlanId != nil) {
                        timeline.removeRepeatPlan(at: IndexSet(integer: plannedTask.attachedRepeatPlanId!))
                    } else {
                        timeline.removeRecord(at: IndexSet(integer: plannedTask.id))
                    }
                }
            }
            .timelineCardify(
                color: timeline.taskCategory(id: plannedTask.taskCategoryId).color,
                time: plannedTask.beginTime)
    }
    
    func todoTaskItem(todoTask: TodoTask) -> some View {
        TodoTaskCard(todoTask: todoTask)
            .contextMenu {
                AnimatedActionButton(title: "编辑", systemImage: "square.and.pencil") {
                    needToAdd = false
                    todoTaskToEdit = todoTask }
                AnimatedActionButton(
                    title: todoTask.attachedRepeatPlanId == nil ? "删除" : "删除重复待办",
                    systemImage: "xmark.square") {
                    if (todoTask.attachedRepeatPlanId != nil) {
                        timeline.removeRepeatPlan(at: IndexSet(integer: todoTask.attachedRepeatPlanId!))
                    } else {
                        timeline.removeRecord(at: IndexSet(integer: todoTask.id))
                    }
                }
            }
            .timelineCardify(
                color: Color(red: 1, green: 0.85, blue: 0.35),
                time: todoTask.beginTime!)
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        ApplicationView()
            .environmentObject(timeline)
    }
}
