//
//  ExchangeRateCalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/16/25.
//

import UIKit

final class ExchangeRateCalculatorViewController: UIViewController {
    private let rootView = ExchangeRateCalculatorView()
    private let exchangeRate: ExchangeRate
    
    enum AmountTextFieldErrorType {
        case emptyError
        case inputError
        
        var description: String {
            switch self {
            case .emptyError:
                return "금액을 입력해주세요."
            case .inputError:
                return "올바른 숫자를 입력해주세요"
            }
        }
    }
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.delegate = self
        setNavigationBar()
        rootView.configure(exchangeRate)
    }
    
    private func showErrorAlert(errorType: AmountTextFieldErrorType) {
        let alert = UIAlertController(title: "오류", message: errorType.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "환율 계산기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ExchangeRateCalculatorViewController: UITextFieldDelegate {
    
}

extension ExchangeRateCalculatorViewController: ExchangeRateCalculatorViewDelegate {
    func didTabConvertButton(_ input: String) {
        if input.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showErrorAlert(errorType: .emptyError)
            }
        } else if !input.isNumber {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showErrorAlert(errorType: .inputError)
            }
        } else {
            guard let input = Double(input),
            let rate = Double(exchangeRate.rate) else { return }
            let amount = input * rate
            
            rootView.updateConvertedAmount(
                String(format: "%.2f", amount),
                currencyCode: exchangeRate.currencyCode
            )
        }
    }
}
