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
