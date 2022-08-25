//
//  DateExtension.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 31/05/22.
//

import Foundation

extension Date {
    func isSameDay(date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: date)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func toString(with format: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        let dateStr = inputFormatter.string(from: self)
        
        return dateStr
    }
    
    func getAllDaysInWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: self)
        var week: [Date] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        return week
    }

    func getAllDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        var days: [Date] = []
        let range = calendar.range(of: .day, in: .month, for: self)!
                
        var day = firstDayOfTheMonth()
        for _ in 1...range.count {
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
    
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
}


func checkDate() {
    var calendar = Calendar.current
    calendar.firstWeekday = 0

    // Difference in weeks:
//    let components = calendar.dateComponents(
//      [.weekOfMonth], from: Date().firstDayOfTheMonth(), to: Date().lastDayOfMonth())
//    let weeks = calendar.date  dateFromComponents(components)!
//    print(dateFormatter.stringFromDate(startOfMonth))
//    print("Weeks: \(weeks)")
}

extension Date {
    
    var startOfWeek: Date? {
        let calendar = Calendar.current
        var components: DateComponents? = calendar.dateComponents([.weekday, .year, .month, .day], from: self)
        var modifiedComponent = components
        modifiedComponent?.day = (components?.day ?? 0) - ((components?.weekday ?? 0) - 1)
        
        return calendar.date(from: modifiedComponent!)
    }
    
    var endOfWeek: Date? {
        let calendar = Calendar.current
        var components: DateComponents? = calendar.dateComponents([.weekday, .year, .month, .day], from: self)
        var modifiedComponent = components
        modifiedComponent?.day = (components?.day ?? 0) + (7 - (components?.weekday ?? 0))
        modifiedComponent?.hour = 23
        modifiedComponent?.minute = 59
        modifiedComponent?.second = 59
        
        return calendar.date(from: modifiedComponent!)
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(
            from:
                Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    func lastDayOfMonth() -> Date {
        return Calendar.current.date(
            byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfTheMonth())!
    }
}
