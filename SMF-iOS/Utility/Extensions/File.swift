//
//  File.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 01/06/22.
//

import Foundation
import FSCalendar

extension FSCalendar {
    func selectWeek(date: Date) {
//        let weekDate = Calendar.current.date(byAdding: .day, value: 8, to: date)
//        let week = weekDate?.getAllDaysInWeek()
        let week = date.getAllDaysInWeek()
        week.forEach { date in
            self.select(date)
        }
    }
    
    func selectMonth(date: Date) {
        let month = date.getAllDaysInMonth()
        month.forEach { date in
            self.select(date)
        }
    }
}
