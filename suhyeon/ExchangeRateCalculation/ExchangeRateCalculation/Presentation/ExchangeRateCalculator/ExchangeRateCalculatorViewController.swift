//
//  ExchangeRateCalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

class ExchangeRateCalculatorViewController: UIViewController {
    private let calculatorView = ExchangeRateCalculatorView()
    private let exchangeRate: ExchangeRate

    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = calculatorView
        calculatorView.configure(with: exchangeRate)
    }
}
