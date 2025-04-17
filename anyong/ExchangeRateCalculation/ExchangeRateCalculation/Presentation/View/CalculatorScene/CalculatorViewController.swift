//
//  CalculatorViewController.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/16/25.
//

import UIKit

final class CalculatorViewController: UIViewController {
    private let rootView = CalculatorView()
    private let viewModel: CalculatorViewModel
    
    init(exchangeRate: ExchangeRate) {
        self.viewModel = CalculatorViewModel(exchangeRate: exchangeRate)
        
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
                
        setNavigationBar()
        bind()
        viewModel.action?(.initialize)
    }
    
    private func bind() {
        rootView.delegate = self
        
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.rootView.configure(
                    currencyCode: state.currencyCode,
                    nation: state.nation
                )
                
                if let result = state.result {
                    self.rootView.updateConvertedAmount(result)
                }
                
                if let error = state.errorMessage {
                    self.showErrorAlert(message: error)
                }
            }
        }
        
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "환율 계산기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    
}

extension CalculatorViewController: CalculatorViewDelegate {
    func didTabConvertButton(_ input: String) {
        viewModel.action?(.convert(input: input))
    }
}
