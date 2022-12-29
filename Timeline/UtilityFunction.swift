//
//  UtilityFunction.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import Foundation

// 计算两个时间间隔秒数
func intervalSeconds(between beginTime: Date, and endTime: Date) -> Int {
    return Calendar.current.dateComponents(
        [.second], from: beginTime, to: endTime).second!
}
