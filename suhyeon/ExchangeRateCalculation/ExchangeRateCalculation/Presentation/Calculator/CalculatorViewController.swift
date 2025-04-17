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
        configure()
    }
}

extension CalculatorViewController: CalculatorViewDelegate {
    func calculatorView(_ view: CalculatorView, didTapConvertButtonWith amountTextField: UITextField) {
        guard let text = amountTextField.text, !text.isEmpty else {
            self.showErrorAlert(
                title: "오류",
                message: "금액을 입력해주세요."
            )
            return
        }
        guard let amount = Double(text) else {
            self.showErrorAlert(
                title: "오류",
                message: "올바른 숫자를 입력해주세요."
            )
            return
        }

        view.setCalculatorResult(with: amount * exchangeRate.rate, currency: exchangeRate.currency)
    }
}

private extension CalculatorViewController {
    func configure() {
        calculatorView.delegate = self
        setNavigationBar(title: "환율 계산기", isLargeTitle: true)
        calculatorView.configure(with: exchangeRate)
    }
}
