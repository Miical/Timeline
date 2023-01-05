//
//  statisticsView.swift
//  Timeline
//
//  Created by Jason Liu on 2023/1/5.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var timeline: Timeline
    @Binding var selectedDate: Date
    @Binding var isPresentSideBar: Bool
    var data: [Pie] {
        timeline.getStatisticsData(for: selectedDate)
    }
    var body: some View {
        VStack {
            titleBar
            Spacer(minLength: 50)
            
            if data.isEmpty {
                Text("暂无数据")
            } else {
                pieChart
                dataTable
            }
            
            Spacer(minLength: 0)
        }
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
                
                Spacer()
                
                Text("统计")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "plus")
                    .foregroundColor(.black)
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
    var pieChart: some View {
        GeometryReader{ g in
            ZStack {
                ForEach(data.indices, id: \.self) { i in
                    DrawShape(center: CGPoint(x: g.frame(in: .global).width / 2,
                                              y: g.frame(in: .global).height / 2), data: data, index: i)
                }
            }
        }
        .frame(height: 200)
        .clipShape(Circle())
        .shadow(radius: 10)
    }
    var dataTable: some View {
        ScrollView {
            ForEach(data) { pie in
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundColor(.white)
                        .shadow(color: Color(red: 0.9, green: 0.9, blue: 0.9), radius: 3)
                    
                    VStack {
                        HStack {
                            timeline.taskCategoryList[pie.id].icon
                            Text(pie.name)
                            Spacer(minLength: 0)
                        }
                        .font(.callout)
                        HStack {
                            GeometryReader { geometry in
                                VStack {
                                    Spacer(minLength: 0)
                                    HStack {
                                        Rectangle()
                                            .fill(pie.color.opacity(0.6))
                                            .frame(width: self.getWidth(width: geometry.frame(in: .global).width,
                                                                        value: pie.percent),
                                                   height: 10.0)
                                            .shadow(color: Color(red: 0.9, green: 0.9, blue: 0.9), radius: 3)
                                        Spacer()
                                    }
                                    Spacer(minLength: 0)
                                }
                            }
                            Spacer(minLength: 0)
                            Text("\(timeStringFromSeconds(pie.data))")
                                .frame(width: 80.0)
                                .font(.footnote)
                        }
                    }
                        .padding()
                }
                .padding(.horizontal, 30.0)
            }
            Spacer()
        }
        .padding(.top, 30)
    }
    
    func getWidth(width: CGFloat, value: CGFloat) -> CGFloat {
        let temp = value / 100
        return temp * width
    }
}

struct DrawShape: View {
    var center: CGPoint
    var data: [Pie]
    var index: Int
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: self.center)
                path.addArc(center: self.center,
                            radius: 180,
                            startAngle: .init(degrees: self.from()),
                            endAngle: .init(degrees: self.to()),
                            clockwise: false)
            }
            .fill(data[index].color.opacity(0.55))
            
            Path { path in
                path.move(to: self.center)
                path.addArc(center: self.center,
                            radius: 180,
                            startAngle: .init(degrees: self.from()),
                            endAngle: .init(degrees: self.to()),
                            clockwise: false)
            }
            .stroke(lineWidth: 3.0)
            .foregroundColor(backgroundColor.opacity(0.8))
        }
    }
    
    func from() -> Double {
        if index == 0 {
            return 0
        } else {
            
            var temp: Double = 0
            for i in 0...index-1 {
                temp += Double(data[i].percent / 100) * 360
            }
            return temp
        }
    }
    
    func to() -> Double {
        var temp: Double = 0
        for i in 0...index {
            temp += Double(data[i].percent / 100) * 360
        }
        return temp
    }
}


struct Pie: Identifiable{
    var id: Int
    var percent: CGFloat
    var data: Int
    var name: String
    var color: Color
}
