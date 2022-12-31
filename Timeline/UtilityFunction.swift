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

// 将 Date 类型转换为 yyyy/MM/dd hh:mm:ss 格式的字符串
func getDateTimeString(of time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
    return dateFormatter.string(from: time)
}

// 将 Date 类型转换为 hh:mm:ss 格式的字符串
func getTimeString(of time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss"
    return dateFormatter.string(from: time)
}
    
// 将秒数转换为时分秒表示的字符串
func timeStringFromSeconds(_ seconds: Int) -> String {
    var timeString = "\(seconds % 60)s"
    if seconds / 60 > 0 {
        timeString = "\(seconds / 60 % 60)m " + timeString
    }
    if seconds / 3600 > 0 {
        timeString = "\(seconds / 3600)h " + timeString
    }
    return timeString
}
