//
//  Date+.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/22/25.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
