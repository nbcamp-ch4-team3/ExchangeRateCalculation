//
//  DetailViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/16/25.
//

import UIKit

class DetailViewController: UIViewController {
    let viewModel: DetailViewModel
    private let detailView = DetailView()
    
    override func loadView() {
        super.loadView()
        
        view = detailView
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "환율 계산기"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        detailView.currencyLabel.text = viewModel.currency.code
        detailView.countryLabel.text = viewModel.currency.country
        detailView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        
        viewModel.onValidate = { [weak self] result in
            guard let self, let text = detailView.amountTextField.text else { return }
            
            switch result {
            case .valid(let number):
                detailView.resultLabel.text = "$\(text) → \(String(format: "%.2f", number * viewModel.currency.rate)) \(viewModel.currency.code)"
            case .invalid(let message):
                showError(message: message)
                detailView.amountTextField.text = ""
            }
        }
    }
    
    @objc func convertButtonTapped() {
        let text = detailView.amountTextField.text
        viewModel.validate(text)
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
