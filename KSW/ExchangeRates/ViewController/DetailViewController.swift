//
//  DetailViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/16/25.
//

import UIKit

class DetailViewController: UIViewController {
    let exchangeRate: ExchangeRate
    
    private let detailView = DetailView()
    
    override func loadView() {
        super.loadView()
        
        view = detailView
    }
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "환율 계산기"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        detailView.currencyLabel.text = exchangeRate.code
        detailView.countryLabel.text = exchangeRate.country
        
        detailView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
    }
    
    @objc func convertButtonTapped() {
        let text = detailView.amountTextField.text
        validate(text)
    }
    
    // 텍스트 필드 사용자 입력값 검증
    private func validate(_ text: String?) {
        guard let text else { return }
        
        // 입력값이 없을 때
        if text.isEmpty {
            showError(message: "금액을 입력해주세요.")
            return
        }
        
        // 입력값이 있을 때
        if let number = Double(text) {
            // 입력값 정상
            detailView.resultLabel.text = "$\(text) → \(String(format: "%.2f", number * exchangeRate.rate)) \(exchangeRate.code)"
        } else {
            // 입력값이 숫자가 아닐 때
            showError(message: "올바른 숫자를 입력해주세요.")
            detailView.amountTextField.text = ""
        }
    }
    
    private func showError(message: String) {
        let alertTitle = NSLocalizedString("오류", comment: "Error alert title")
        let alert = UIAlertController(
            title: alertTitle, message: message, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("확인", comment: "Alert OK button title")
        alert.addAction(
            UIAlertAction(
                title: actionTitle, style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
        present(alert, animated: true, completion: nil)
    }
}
