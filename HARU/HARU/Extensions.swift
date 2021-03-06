//
//  Extensions.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/21.
//

import Foundation
import UIKit

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    
    var startOfYear: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        
        return calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    var datesOfMonth: [Date] {
        var curDate = startOfMonth
        var dates = [Date]()
        while true {
            if curDate.compare(.isSameDay(as: endOfMonth.adjust(.day, offset: 1))) {
                break
            }
            dates.append(curDate)
            curDate = curDate.adjust(.day, offset: 1)
        }
        return dates
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func numOfDays(In month: Date) -> Int {
        let range = Calendar(identifier: .gregorian).range(of: .day, in: .month, for: month)!
        let numDays = range.count
        return numDays
    }
}

extension Date {
    
    func isSameAs(as compo: Calendar.Component, from date: Date) -> Bool {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        return cal.component(compo, from: date) == cal.component(compo, from: self)
    }
    
    func dayBefore() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

extension UITableView {
    func removeExtraLine() {
        tableFooterView = UIView(frame: .zero)
    }
}
