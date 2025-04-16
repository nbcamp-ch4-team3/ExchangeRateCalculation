//
//  ExchangeRateCalculatorView.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/16/25.
//

import UIKit

import SnapKit
import Then

protocol ExchangeRateCalculatorViewDelegate: AnyObject {
    func didTabConvertButton(_ input: String)
}

final class ExchangeRateCalculatorView: UIView {
    private let currencyCodeLabel = UILabel()
    private let nationLabel = UILabel()
    private let labelStackView = UIStackView()
    private let amountTextField = UITextField()
    private let convertButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    
    weak var delegate: ExchangeRateCalculatorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        currencyCodeLabel.do {
            $0.font = .systemFont(ofSize: 24, weight: .bold)
            $0.textColor = .black
        }
        
        nationLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .gray
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .center
        }
        
        amountTextField.do {
            $0.placeholder = "금액을 입력하세요"
            $0.keyboardType = .decimalPad
            $0.textAlignment = .center
            $0.borderStyle = .roundedRect
        }
        
        convertButton.do {
            $0.setTitle("환율 계산", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(didTabConvertButton), for: .touchUpInside)
        }
        
        resultLabel.do {
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    private func setUI() {
        labelStackView.addArrangedSubviews(currencyCodeLabel, nationLabel)
        addsubViews(labelStackView, amountTextField, convertButton, resultLabel)
    }
    
    private func setLayout() {
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
}

extension ExchangeRateCalculatorView {
    func configure(_ exchangeRate: ExchangeRate) {
        currencyCodeLabel.text = exchangeRate.currencyCode
        nationLabel.text = exchangeRate.nation
    }
    
    func updateConvertedAmount(_ convertedAmount: String, currencyCode code: String) {
        guard let text = amountTextField.text,
              let doubleText = Double(text) else { return }
        let convertText = String(format: "%.2f", doubleText)
        let output = "$\(convertText) → \(convertedAmount) \(code)"
        resultLabel.text = output
    }
    
    @objc
    private func didTabConvertButton() {
        delegate?.didTabConvertButton(amountTextField.text ?? "")
    }
}
