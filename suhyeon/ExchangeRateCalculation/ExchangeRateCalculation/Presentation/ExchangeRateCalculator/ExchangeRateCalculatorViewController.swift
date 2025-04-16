//
//  ExchangeRateCalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

class ExchangeRateCalculatorViewController: UIViewController {
    private let calculatorView = ExchangeRateCalculatorView()

    override func viewDidLoad() {
        view = calculatorView
    }
}
