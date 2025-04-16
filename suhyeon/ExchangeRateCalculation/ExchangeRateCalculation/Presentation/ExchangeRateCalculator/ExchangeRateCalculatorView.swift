//
//  ExchangeRateCalculatorView.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

class ExchangeRateCalculatorView: UIView {
    // 타이틀 라벨("환율 계산기")
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산기"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()

    // currencyLabel + countryLabel
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "ALL"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "엘바니아"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()

    // 금액 입력 텍스트 필드
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.placeholder = "금액을 입력하세요."
        return textField
    }()

    // 변환 버튼
    let convertButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("환율 계산", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        return button
    }()

    // 결과 라벨
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "계산 결과가 여기에 표시됩니다"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ExchangeRateCalculatorView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy(){
        labelStackView.addArrangedSubviews(views: currencyLabel, countryLabel)
        self.addSubviews(views: titleLabel, labelStackView, amountTextField, convertButton, resultLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
}
