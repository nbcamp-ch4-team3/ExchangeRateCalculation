//
//  ExchangeRateCell.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
    static let id = "ExchangeRateCell"

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()


    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: ExchangeRate) {
        countryLabel.text = data.country
        currencyLabel.text = data.currency
        rateLabel.text = data.rate.formatted(toDecimalDigits: 4)
    }
}

private extension ExchangeRateCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        self.backgroundColor = .white
    }

    func setHierarchy() {
        labelStackView.addArrangedSubviews(views: currencyLabel, countryLabel)
        self.contentView.addSubviews(views: labelStackView, rateLabel)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
    }
}
