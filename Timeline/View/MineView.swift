//
//  MineView.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/3.
//

import SwiftUI

struct MineView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 20)
                    .background { Color.white }
                VStack {
                    HStack {
                        NavigationLink(destination: TaskCategoryManagementView()) {
                            cardView(systemName: "list.bullet", name: "任务分类管理")
                        }
                        Spacer()
                        cardView(systemName: "calendar.badge.clock", name: "重复任务管理")
                    }
                    .padding()
                    Spacer()
                }
                .background(backgroundColor)
            }
            .navigationBarTitleDisplayMode(.automatic)
            .navigationTitle("任务管理")
        }
    }
    
    func cardView(systemName: String, name: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 4)
            VStack {
                Image(systemName: systemName)
                    .font(.largeTitle)
                    .padding()
                Text(name)
            }
            .foregroundColor(.black.opacity(0.7))
        }
        .padding(10)
        .aspectRatio(1.0, contentMode: .fit)
        
    }
}

struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}
