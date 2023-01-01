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
    
    var body: some View {
        ZStack {
            VStack {
                titleBar
                Spacer(minLength: 0)
                timelineBody
            }
            
            // Text("2343")
            // .turnToEditor(isPresent: .constant(true), title: "编辑", onSave: {})
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
                        CompletedTaskCard(completedTask: completedTask)
                            .contextMenu {
                                AnimatedActionButton(title: "编辑", systemImage: "square.and.pencil") {
                                }
                            }
                            .timelineCardify(
                                color: timeline.taskCategory(id: completedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
                    case .plannedTask(let plannedTask):
                        PlannedTaskCard(plannedTask: plannedTask)
                            .timelineCardify(
                                color: timeline.taskCategory(id: plannedTask.taskCategoryId).color,
                                time: record.getBeginTime()!)
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
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        ApplicationView()
            .environmentObject(timeline)
    }
}
