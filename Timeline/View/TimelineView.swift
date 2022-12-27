//
//  TimelineView.swift
//  Timeline
//
//  Created by Jason Liu on 2022/12/27.
//

import SwiftUI

struct TimelineView: View {
    var timeline: Timeline
    
    var body: some View {
        Text("时光轴")
        VStack {
            ForEach(timeline.allRecord(for: Date())) { record in
                EventCard(record: record).padding(.all)
            }
        }
    }
}

struct EventCard: View {
    var record: Record
    
    var body: some View {
        ZStack {
            Rectangle().stroke(lineWidth: 3)
            Text("\(record.getTime()!)")
        }
    }
    
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = Timeline()
        TimelineView(timeline: timeline)
    }
}
