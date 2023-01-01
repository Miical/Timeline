//
//  Editor.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/1.
//

import SwiftUI

struct Editor: ViewModifier {
    @Binding var isPresent: Bool
    var title: String
    var onSave: () -> Void
    
    func body(content: Content) -> some View {
        ZStack() {
            Rectangle()
                .background(.white)
                .opacity(0.2)
                .onTapGesture(perform: {})
                .onLongPressGesture(perform: {})
            
            HStack {
                Spacer(minLength: 30)
                
                VStack {
                    titleSection
                    Divider()
                    content
                    saveButton
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 30)
            }
        }
    }
    
    var titleSection: some View {
        HStack {
            Button(action: {
                isPresent = false
            }, label: {
                Image(systemName: "xmark.circle")
                    .scaleEffect(1.3)
            })
            .foregroundColor(.gray)
            Spacer()
            Text(title)
                .font(.title3)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            Spacer()
        }
    }
    
    var saveButton: some View {
        Button(action: {
            onSave()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 1, green: 0.85, blue: 0.35))
                    .frame(height: 45)
                Text("保存")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        })
    }
}

struct TextEditor: View {
    var name: String
    @Binding var text: String
    var wordsLimit: Int
    
    var body: some View {
        HStack {
            Text(name + "：")
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            TextField("请输入" + name, text: $text)
                .onChange(of: text) { newValue in
                    if newValue.count > wordsLimit {
                        text = String(text.prefix(wordsLimit))
                    }
                }
        }
        .padding(12)
    }
}

struct TaskCategorySelector: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var taskCategory: TaskCategory
    
    var body: some View {
        HStack {
            Text("任务分类：")
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            Spacer(minLength: 50)
            
            Menu {
                ForEach (timeline.taskCategoryList) { taskCategoryToSelect in
                    AnimatedActionButton(title: taskCategoryToSelect.name, systemImage: taskCategoryToSelect.iconSystemName) {
                        taskCategory = taskCategoryToSelect
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(taskCategory.color)
                    .opacity(0.8)
                    .overlay {
                        HStack {
                            taskCategory.icon
                            Text(taskCategory.name)
                        }
                        .foregroundColor(.white)
                    }
            }
        }
        .frame(height: 50)
        .padding(12)
    }
}

struct TimeEditor: View {
    var name: String
    @Binding var time: Date
    var body: some View {
        HStack {
            Text(name + "：")
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            Spacer()
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
        }
        .padding(12)
    }
}

struct ThemeColorPicker: View {
    @Binding var color: RGBAColor
    var body: some View {
        HStack {
            Text("主题色：")
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            Spacer()
            ColorPicker(selection: Binding(
            get: {
                Color(rgbaColor: color)
            },
            set: {
                color = RGBAColor(color: $0)
            })){}
        }
        .padding(12)
    }
}


struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Text("33")
            .turnToEditor(isPresent: .constant(true), title: "编辑", onSave: {})
            .environmentObject(Timeline())
    }
}
