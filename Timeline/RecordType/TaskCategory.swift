//
//  TaskCategory.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

struct TaskCategory: Codable, Identifiable {
    var name: String
    var themeColor: RGBAColor
    var id: String { name }
}


// RGBAColor
// 使用四个Double类型变量存储颜色值，该类型的颜色值表示支持Codable协议，
// 方便将颜色值编码为各种格式。
struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}
