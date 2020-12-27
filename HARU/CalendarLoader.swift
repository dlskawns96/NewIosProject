//
//  CalendarLoader.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import Foundation
import EventKit
import UIKit

class CalendarLoader {
    
    struct EVENT {
        var startDate: NSDate
        var endDate: NSDate
        var title: String
        var calendarName: String
        var color: UIColor
    }
    
    // To save calendars properties
    var loadedEvents: [EVENT] = []
    
    let eventStore = EKEventStore()
    let calendars : [EKCalendar]
    
    init() {
        var auth: Bool = false
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
                auth = true
        case .denied:
                print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                    if granted {
                        auth = true

                    }else{
                        print("Access denied")
                    }
                })
            default:
                print("Case Default")
            }
        
        calendars = eventStore.calendars(for: .event)
        
        if auth {
            loadEvents()
        }
    }
    
    func loadEvents() {
        for calendar in calendars {
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)

            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])

            let events = eventStore.events(matching: predicate)

            for event in events {
                let calendarColor = UIColor(cgColor: calendar.cgColor)
                let ev = EVENT(startDate: event.startDate as NSDate, endDate: event.endDate as NSDate, title: event.title,
                                  calendarName: event.calendar.title, color: calendarColor)
                
                loadedEvents.append(ev)
            }
        }
    }
}
