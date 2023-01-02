//
//  TimingView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimingView: View {
    @EnvironmentObject var timeline: Timeline
    
    @State var timer: Timer?
    @State var timeCostInSeconds: Int = 0
    
    @State var attachedPlannedTask: PlannedTask? = PlannedTask(beginTime: Date(), endTime: Date(), taskCategoryId: 0, taskDescription: "jihus", id: 0)
    @State var taskDescription: String = ""
    @State var selectedTaskCategory: TaskCategory?
    
    @State var progress: CGFloat = 0.0
    @State var reverse = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                clock(geometry: geometry)
                taskDetail
                
                Spacer()
                if attachedPlannedTask != nil { plannedTaskControlButtons }
                else { controlButtons }
                Spacer()
            }
        }
    }
    
    func clock(geometry: GeometryProxy) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .blur(radius: 5)
                .padding(-42)
            Circle()
                .trim(from: reverse ? progress : 0,
                      to: reverse ? 1 : progress)
                .stroke(timelineThemeColor.opacity(1),lineWidth: 80)
                .blur(radius: 3)
                .opacity(0.2)
            Circle()
                .stroke(Color(red: 1, green: 0.85, blue: 0.35), lineWidth: 20)
                .blur(radius: 15)
            ZStack{
                Circle().fill(backgroundColor)
                    .blur(radius: 3)
                let timeText = String(format: "%02d:%02d:%02d",
                                      timeCostInSeconds / 3600,
                                      timeCostInSeconds % 3600 / 60,
                                      timeCostInSeconds % 60)
                Text(timeText)
                    .font(.title)
                    .fontWeight(.medium)
            }
            .rotationEffect(.init(degrees: -270))
            
            Circle()
                .trim(from: reverse ? progress : 0,
                      to: reverse ? 1 : progress)
                .stroke(timelineThemeColor, lineWidth: 10)
                .opacity(0.8)
            
            GeometryReader { geometry in
                let size = geometry.size
                
                Circle()
                    .fill(timelineThemeColor)
                    .frame(width: 30, height: 30)
                    .overlay(content: {
                        Circle()
                            .fill(.white)
                            .padding(5)
                    })
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .offset(x: size.height / 2)
                    .rotationEffect(.init(degrees: progress * 360))
            }
        }
        .padding(80)
        .frame(height: geometry.size.width)
        .rotationEffect(.init(degrees: -90))
    }
    
    var taskDetail: some View {
        VStack {
            if attachedPlannedTask != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray.opacity(0.1))
                    AnimatedActionButton(
                        title: "计划任务 " + getTimeString(of:  attachedPlannedTask!.beginTime),
                        systemImage: "xmark") {
                            attachedPlannedTask = nil
                        }
                        .foregroundColor(.gray)
                }
                .frame(height: 50)
                .padding(.horizontal, 80)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray.opacity(0.1))
                VStack {
                    if let attachedPlannedTask = attachedPlannedTask {
                        HStack {
                            timeline.taskCategory(id: attachedPlannedTask.taskCategoryId).icon
                                .padding(.horizontal, 40)
                            Spacer()
                            Text(timeline.taskCategory(id: attachedPlannedTask.taskCategoryId).name)
                                .padding(.horizontal, 40)
                        }
                        .foregroundColor(.gray)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    } else {
                        Menu {
                            ForEach(timeline.taskCategoryList) { taskCategory in
                                AnimatedActionButton(title: taskCategory.name, systemImage: taskCategory.iconSystemName) {
                                    selectedTaskCategory = taskCategory
                                }
                            }
                        } label: {
                            if let taskCategory = selectedTaskCategory {
                                HStack {
                                    taskCategory.icon
                                        .padding(.horizontal, 40)
                                    Spacer()
                                    Text(taskCategory.name)
                                        .padding(.horizontal, 40)
                                }
                                .foregroundColor(.gray)
                            } else {
                                Text("选择任务类别")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    if let attachedPlannedTask = attachedPlannedTask {
                        HStack {
                            Text(attachedPlannedTask.taskDescription)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.gray)
                                .padding()
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                    } else {
                        TextField("任务描述", text: $taskDescription)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.gray)
                            .padding()
                            .padding(.horizontal, 10)
                    }
                    Spacer()
                }
            }
            .frame(height: 30)
            .padding(50)
        }
    }
    
    var controlButtons: some View {
        HStack {
            if timeline.ongoingTask == nil {
                Button {
                    progress = 0
                    withAnimation { startTask() }
                } label: {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 100, height: 40)
                                .foregroundColor(.green.opacity(0.8))
                            Text("开始")
                                .foregroundColor(.white)
                        }
                    }
                }
            } else {
                Spacer()
                Button {
                    withAnimation { endTask() }
                } label: {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 100, height: 40)
                                .foregroundColor(.red.opacity(0.8))
                            Text("结束")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        endTask()
                        startTask()
                    }
                    progress = 0
                } label: {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 100, height: 40)
                                .foregroundColor(.green.opacity(0.8))
                            Text("切换任务")
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    var plannedTaskControlButtons: some View {
        HStack {
            if attachedPlannedTask != nil {
                if !attachedPlannedTask!.isOver {
                    if !attachedPlannedTask!.isExecuting {
                        Spacer()
                        Button {
                            withAnimation {
                                attachedPlannedTask!.changeState(at: Date())
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    timeCostInSeconds = attachedPlannedTask!.totalExecutionTimeInSeconds
                                    
                                    progress = CGFloat((timeCostInSeconds % 60)) / 60.0
                                    if progress == 0 {
                                        reverse.toggle()
                                    }
                                }
                            }
                            if (!attachedPlannedTask!.isExecuted) {
                                progress = 0
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: 100, height: 40)
                                    .foregroundColor(.green.opacity(0.8))
                                Text(attachedPlannedTask!.isExecuted ? "继续" : "开始")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if attachedPlannedTask!.isExecuted {
                            Spacer()
                            Button {
                                withAnimation {
                                    attachedPlannedTask!.isOver = true
                                    timeline.modifyPlannedTask(with: attachedPlannedTask!)
                                    timer?.invalidate()
                                }
                            } label: {
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 100, height: 40)
                                            .foregroundColor(.red.opacity(0.8))
                                        Text("结束")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        Spacer()
                    } else {
                        Spacer()
                        Button {
                            withAnimation {
                                attachedPlannedTask!.changeState(at: Date())
                                timer?.invalidate()
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 100, height: 40)
                                        .foregroundColor(.gray.opacity(0.8))
                                    Text("暂停")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Spacer()
                        Button {
                            withAnimation {
                                attachedPlannedTask!.changeState(at: Date())
                                attachedPlannedTask!.isOver = true
                                timeline.modifyPlannedTask(with: attachedPlannedTask!)
                                timer?.invalidate()
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 100, height: 40)
                                        .foregroundColor(.red.opacity(0.8))
                                    Text("结束")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    func startTask() {
        if selectedTaskCategory != nil {
            timeCostInSeconds = 0
            timeline.startATask(of: selectedTaskCategory!, with: taskDescription, at: Date())
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                timeCostInSeconds = intervalSeconds(between: timeline.ongoingTask!.beginTime, and: Date())
                progress = CGFloat((timeCostInSeconds % 60)) / 60.0
                if progress == 0 {
                    reverse.toggle()
                }
            }
        }
    }
    
    func endTask() {
        timeline.endTask(at: Date())
        timer?.invalidate()
    }
}

struct TimingView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView()
            .environmentObject(Timeline())
    }
}
