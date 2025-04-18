//
//  ExchangeRateCell.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit
import SnapKit

protocol ExchangeRateCellDelegate: AnyObject {
    func didTapStarButton(with currency: String)
}

final class ExchangeRateCell: UITableViewCell {
    static let id = "ExchangeRateCell"
    weak var delegate: ExchangeRateCellDelegate?

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

    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        button.isEnabled = true

        button.addTarget(self, action: #selector(touchUpInsideStarButton), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil

        countryLabel.text = nil
        currencyLabel.text = nil
        rateLabel.text = nil
    }

    func configure(with data: ExchangeRate) {
        countryLabel.text = data.country
        currencyLabel.text = data.currency
        rateLabel.text = data.rate.formatted(toDecimalDigits: 4)
        starButton.isSelected = data.isFavorite
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
        self.contentView.addSubviews(views: labelStackView, rateLabel, starButton)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(starButton.snp.leading).offset(-16)
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }

        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }

    @objc func touchUpInsideStarButton() {
        guard let currency = currencyLabel.text else { return }
        starButton.isSelected.toggle()
        delegate?.didTapStarButton(with: currency)
    }
}
