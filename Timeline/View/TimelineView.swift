//
//  TimelineView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var timeline: Timeline
    @State var completedTaskEditor = false
    @State var plannedTaskToExecute: PlannedTask?
    
    @State var needToAdd = false
    @State var completedTaskToEdit: CompletedTask?
    @State var plannedTaskToEdit: PlannedTask?
    
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
            }
        }
    }
    
    var titleBar: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }.padding(.leading, 15.0)
            
            Spacer(minLength: 0)
            
            Label("Timeline", systemImage: "calendar.day.timeline.leading")
                .font(.custom("AvenirNextCondensed-DemiBold", size: 18))
            
            Spacer(minLength: 0)
            
            Button(action: {
                
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
            }.padding(.trailing, 15.0)
        }
        .padding()
        .background { Color.white }
    }
    
    var timelineBody: some View {
        VStack {
            ScrollView {
                ForEach(timeline.allRecords(for: Date())) { record in
                    switch(record) {
                    case .completedTask(let completedTask) :
                        completedTaskItem(completedTask: completedTask)
                    case .plannedTask(let plannedTask):
                        plannedTaskItem(plannedTask: plannedTask)
                    case .todoTask(let todoTask):
                        TodoTaskCard(todoTask: todoTask)
                            .timelineCardify(
                                color: .yellow,
                                time: record.getBeginTime()!)
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
                AnimatedActionButton(title: "编辑", systemImage: "square.and.pencil") {
                    plannedTaskToEdit = plannedTask}
                AnimatedActionButton(title: "删除", systemImage: "xmark.square") {
                    timeline.removeRecord(at: IndexSet(integer: plannedTask.id))
                }
            }
            .timelineCardify(
                color: timeline.taskCategory(id: plannedTask.taskCategoryId).color,
                time: plannedTask.beginTime)
    }
    
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        ApplicationView()
            .environmentObject(timeline)
    }
}
