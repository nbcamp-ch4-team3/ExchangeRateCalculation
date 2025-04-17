//
//  ExchangeRateCell.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import UIKit

final class ExchangeRateCell: UITableViewCell {
    static let identifier = "ExchangeRateCell"
    
    private let currencyCodeLabel = UILabel()
    private let nationLabel = UILabel()
    private let labelStackView = UIStackView()
    private let rateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        currencyCodeLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
        
        nationLabel.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        rateLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.textAlignment = .right
        }
    }
    
    private func setUI() {
        labelStackView.addArrangedSubviews(currencyCodeLabel, nationLabel)
        addsubViews(labelStackView, rateLabel)
    }
    
    private func setLayout() {
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
    }
}

extension ExchangeRateCell {
    func configure(currencyCode: String, nation: String, rate: Double) {
        currencyCodeLabel.text = currencyCode
        nationLabel.text = nation
        rateLabel.text = String(format: "%.4f", rate)
    }
}
