//
//  File.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 01/06/22.
//

import Foundation
import FSCalendar

extension FSCalendar {
    func selectWeek() {
        let date = Calendar.current.date(byAdding: .day, value: 8, to: Date())
        let week = date?.getAllDaysInWeek()
        week?.forEach { date in
            self.select(date)
        }
    }
    
    func selectMonth() {
        let month = Date().getAllDaysInMonth()
        month.forEach { date in
            self.select(date)
        }
    }
}
