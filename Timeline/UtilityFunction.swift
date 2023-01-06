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

/// 将 Date 类型转换为 yyyy/MM/dd hh:mm:ss 格式的字符串
func getDateTimeString(of time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
    return dateFormatter.string(from: time)
}

/// 将 Date 类型转换为 yyyy-MM-dd 格式的字符串
func getDateString(of time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: time)
}


/// 将 Date 类型转换为 hh:mm:ss 格式的字符串
func getTimeString(of time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss"
    return dateFormatter.string(from: time)
}
    
/// 将秒数转换为时分秒表示的字符串
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

/// 由给定的时间日期生成新的Date对象
func connectDateAndTime(date: Date, time: Date) -> Date {
    let calendar = Calendar.current
    
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: time)
    let minute = calendar.component(.minute, from: time)
    let second = calendar.component(.second, from: time)
    
    return calendar.date(from: DateComponents(
        calendar: calendar, year: year, month: month, day: day,
        hour: hour, minute: minute, second: second))!
}

/// 获取一天的开始
func getTheStartOf(date: Date) -> Date {
    let calendar = Calendar.current
    
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    return calendar.date(from: DateComponents(
        calendar: calendar, year: year, month: month, day: day,
        hour: 0, minute: 0, second: 0))!
}
