//
//  ExchangeRateCell.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import UIKit

protocol ExchangeRateCellDelegate: AnyObject {
    func didTapStarButton(_ code: String, _ selected: Bool)
}

final class ExchangeRateCell: UITableViewCell {
    static let identifier = "ExchangeRateCell"
    
    private let currencyCodeLabel = UILabel()
    private let nationLabel = UILabel()
    private let labelStackView = UIStackView()
    private let rateLabel = UILabel()
    private let starButton = UIButton()
    
    weak var delegate: ExchangeRateCellDelegate?
    
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
        
        starButton.do {
            $0.setImage(.init(systemName: "star"), for: .normal)
            $0.setImage(.init(systemName: "star.fill"), for: .selected)
            $0.tintColor = .systemYellow            
            $0.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
        }
    }
    
    private func setUI() {
        labelStackView.addArrangedSubviews(currencyCodeLabel, nationLabel)
        contentView.addsubViews(labelStackView, rateLabel, starButton)
    }
    
    private func setLayout() {
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
        starButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rateLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
    }
}

extension ExchangeRateCell {    
    func configure(currencyCode: String, nation: String, rate: Double, isSelected: Bool) {
        currencyCodeLabel.text = currencyCode
        nationLabel.text = nation
        rateLabel.text = String(format: "%.4f", rate)
        starButton.isSelected = isSelected
    }
}

extension ExchangeRateCell {
    @objc
    private func didTapStarButton() {
        guard let code = currencyCodeLabel.text else { return }
        starButton.isSelected.toggle()
        delegate?.didTapStarButton(code, starButton.isSelected)
    }
}
