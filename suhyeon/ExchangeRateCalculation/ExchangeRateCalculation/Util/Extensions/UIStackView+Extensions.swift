//
//  UIStackView+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
