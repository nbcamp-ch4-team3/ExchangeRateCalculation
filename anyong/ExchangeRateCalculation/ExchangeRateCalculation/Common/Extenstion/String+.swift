//
//  String+.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/16/25.
//

import Foundation

extension String {
    var isHangul: Bool {
        return range(of: "^[가-힣]+$", options: .regularExpression) != nil
    }
}
