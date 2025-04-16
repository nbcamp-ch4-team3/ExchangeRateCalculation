//
//  CalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
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
        setNavigationBar(title: "환율 계산기", isLargeTitle: true)
        calculatorView.convertButton.addTarget(self, action: #selector(touchUpInsideConvertButton), for: .touchUpInside)
        calculatorView.configure(with: exchangeRate)
    }

    @objc private func touchUpInsideConvertButton() {
        guard let text = calculatorView.amountTextField.text,
              let amount = Double(text) else {
            self.showErrorAlert(
                title: "오류",
                message: "올바른 숫자를 입력해주세요."
            )
            return
        }
        calculatorView.setCalculatorResult(with: amount * exchangeRate.rate, currency: exchangeRate.currency)
    }
}
