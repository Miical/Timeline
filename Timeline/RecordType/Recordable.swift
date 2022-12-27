//
//  Recordable.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import Foundation

protocol Recordable: Codable, Identifiable {
    var beginTime: Date { get set }
    var endTime: Date { get set }
    
}

extension Recordable {
    var durationInSeconds: Int {
        return Calendar.current.dateComponents(
            [.second], from: beginTime, to: endTime).second!
    }
}
