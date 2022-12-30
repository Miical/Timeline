//
//  UtilityFunction.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/29.
//

import Foundation

/// 计算两个时间间隔秒数
func intervalSeconds(between beginTime: Date, and endTime: Date) -> Int {
    return Calendar.current.dateComponents(
        [.second], from: beginTime, to: endTime).second!
}

/// 计算一个日期是星期几
/// 星期天是0，星期一是1，星期二是2，以此类推
func theDayOfTheWeek(at date: Date) -> Int {
    return Calendar.current.component(.weekday, from: date) - 1
}
