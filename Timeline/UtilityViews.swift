//
//  UtilityViews.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

extension View {
    func applyBackGround(color: Color = Color(red: 0.98, green: 0.98, blue: 0.98)) -> some View {
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
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
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

