//
//  TimingView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

// 计时界面
struct TimingView: View {
    @EnvironmentObject var timeline: Timeline
    
    @State var timer: Timer?
    @State var timeCostInSeconds: Int = 0
    @State var taskDescription: String = ""
    @State var progress: CGFloat = 1
    
    var body: some View {
        
        VStack {
            Text("StopWatch Timer")
                .font(.largeTitle)
            Spacer()
            
            GeometryReader { geometry in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(1))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(.white.opacity(1),lineWidth: 80)
                        
                        Circle()
                            .stroke(Color(red: 1, green: 0.85, blue: 0.35), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        ZStack{
                            let timeText = String(format: "%02d:%02d:%02d",
                               timeCostInSeconds / 3600,
                               timeCostInSeconds % 3600 / 60,
                               timeCostInSeconds % 60)
                            
                            Text(timeText)
                                .font(.largeTitle)
                                .fontWeight(.medium)

                            Circle()
                                .fill(Color("BG"))
                        }
                        .rotationEffect(.init(degrees: -270))
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color(red: 1, green: 0.85, blue: 0.35).opacity(1), lineWidth: 10)
                        
                        // 圆环上边的小铃铛
                        GeometryReader { geometry in
                            let size = geometry.size
                            
                            Circle()
                                .fill(Color(red: 1, green: 0.85, blue: 0.35))
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
                        .animation(.easeInOut)
                    }
                    .padding(60)
                    .frame(height: geometry.size.width)
                    .rotationEffect(.init(degrees: -90))
                    
                    if timeline.ongoingTask == nil {
                        Button("Start") {
                            progress = 0
                            startTask()
                        }
                        .font(.largeTitle)
                    } else {
                        Button("切换任务") {
                            endTask()
                            progress = 0
                            startTask()
                        }
                        Button("结束") {
                            endTask()
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background {
                Color("BG")
                    .ignoresSafeArea()
            }
            
            // 在这里变成一个按钮 然后 显示一个列表 选中后 退出列表 开始计时
            // 我感觉最好把任务描述也一起都放在一个统一的Theme Settings里边
            Spacer()
            taskCategoriesBody
            
            TextField("Description", text: $taskDescription).font(.largeTitle)
            Spacer()
            
        }
        .padding()
        .preferredColorScheme(.light)
    }
    
    @State var selectedTaskCategory: TaskCategory?
    
    var taskCategoriesBody: some View {
        ForEach(timeline.taskCategoryList) { taskCategory in
            Text(taskCategory.name).onTapGesture {
                selectedTaskCategory = taskCategory
            }
            .font(selectedTaskCategory?.id == taskCategory.id ? .title : .title2.bold())
        }
    }
    
    func startTask() {
        if selectedTaskCategory != nil {
            timeCostInSeconds = 0
            timeline.startATask(of: selectedTaskCategory!, with: taskDescription, at: Date())
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                timeCostInSeconds = intervalSeconds(between: timeline.ongoingTask!.beginTime, and: Date())
                progress = (progress + 1 / 60)
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
        TimingView()
            .environmentObject(Timeline())
    }
}
