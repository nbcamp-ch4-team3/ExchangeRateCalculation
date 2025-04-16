//
//  UIView+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
