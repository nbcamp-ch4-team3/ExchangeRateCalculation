//
//  CalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit
import os

final class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModel

    init(exchangeRate: ExchangeRate) {
        self.viewModel = CalculatorViewModel(exchangeRate: exchangeRate)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view = calculatorView

        configure()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.state.success = {[weak self] result in
            guard let self else { return }
            calculatorView.setCalculatorResult(
                with: result.calculatedAmount,
                currency: result.currency
            )
        }

        viewModel.state.failure = {[weak self] error in
            guard let self else { return }
            showErrorAlert(title: "오류", message: error.localizedDescription)
            os_log(.error, "%@", error.debugDesciption)
        }
    }
}

extension CalculatorViewController: CalculatorViewDelegate {
    func calculatorView(
        _ view: CalculatorView,
        didTapConvertButtonWith amountTextField: UITextField
    ) {
        viewModel.action?(.calculate(input: amountTextField.text))
    }
}

private extension CalculatorViewController {
    func configure() {
        calculatorView.delegate = self
        setNavigationBar(title: "환율 계산기", isLargeTitle: true)
        calculatorView.configure(with: viewModel.exchangeRate)
    }
}
