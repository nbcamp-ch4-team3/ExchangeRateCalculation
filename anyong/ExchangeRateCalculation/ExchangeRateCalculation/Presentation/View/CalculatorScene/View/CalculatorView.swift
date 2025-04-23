//
//  CalculatorView.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/16/25.
//

import UIKit

import SnapKit
import Then

protocol CalculatorViewDelegate: AnyObject {
    func didTabConvertButton(_ input: String)
}

final class CalculatorView: UIView {
    private let currencyCodeLabel = UILabel()
    private let nationLabel = UILabel()
    private let labelStackView = UIStackView()
    private let amountTextField = UITextField()
    private let convertButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    
    weak var delegate: CalculatorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
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
            $0.textColor = .text
        }
        
        nationLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .secondaryText
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .center
        }
        
        amountTextField.do {
            $0.placeholder = "금액을 입력하세요"
            $0.textColor = .secondaryText
            $0.keyboardType = .decimalPad
            $0.textAlignment = .center
            $0.borderStyle = .roundedRect
        }
        
        convertButton.do {
            $0.setTitle("환율 계산", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = .button
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(didTabConvertButton), for: .touchUpInside)
        }
        
        resultLabel.do {
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.textAlignment = .center
            $0.textColor = .text
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

extension CalculatorView {
    func configure(currencyCode: String, nation: String) {
        currencyCodeLabel.text = currencyCode
        nationLabel.text = nation
    }
    
    func updateConvertedAmount(_ result: String) {
        resultLabel.text = result
    }
    
    @objc
    private func didTabConvertButton() {
        delegate?.didTabConvertButton(amountTextField.text ?? "")
    }
}
