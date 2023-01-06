//
//  UtilityViews.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

var timelineThemeColor =  Color(red: 1, green: 0.85, blue: 0.35)
var backgroundColor =  Color(red: 0.98, green: 0.98, blue: 0.98)

extension View {
    func applyBackGround(color: Color = backgroundColor) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { color }
            .ignoresSafeArea(edges: [.bottom])
    }
}

extension View {
    func timelineCardify(color: Color, time: Date) -> some View {
        return self.modifier(TimelineCardify(themeColor: color, time: time))
    }
}

extension View {
    func turnToEditor(isPresent: Binding<Bool>, title: String,
                    onSave: @escaping () -> Void) -> some View {
        return self.modifier(Editor(isPresent: isPresent, title: title, onSave: onSave))
    }
}

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var delay: Double = 0
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(Animation.easeInOut.delay(delay)) {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}

struct sideBarDatePicker: ViewModifier {
    @Binding var isPresent: Bool
    @Binding var date: Date
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                content
                
                ZStack {
                    if isPresent {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.2))
                            .onTapGesture {
                                withAnimation { isPresent = false }
                            }
                    }
                    
                    HStack {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.5)
                            RoundedRectangle(cornerRadius: 30.0)
                                .foregroundColor(.white)
                            VStack {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("选择日期")
                                }
                                .font(.title2)
                                DatePicker("选择日期", selection: $date, displayedComponents: [.date])
                                    .datePickerStyle(.graphical)
                                    .padding()
                                    .onChange(of: date) { _ in
                                        withAnimation {
                                            isPresent = false
                                        }
                                    }
                            }
                        }
                        .frame(width: geometry.size.width * 0.8)
                        Spacer()
                    }
                }
                .offset(x: isPresent ? 0 : -geometry.size.width * 0.8)
            }
        }
    }
}

extension View {
    func dateSideBar(isPresent: Binding<Bool>, date: Binding<Date>) -> some View {
        return self.modifier(sideBarDatePicker(isPresent: isPresent, date: date))
    }
}
