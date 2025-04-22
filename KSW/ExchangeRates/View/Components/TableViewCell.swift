//
//  TableViewCell.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "TableViewCell"
    
    // 통화 코드(예: USD)
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // 통화 국가(예: 미국)
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // 통화 기호 + 통화 국가(예: USD 미국)
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // 환율(예: 1.000)
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    // 즐겨찾기 버튼
    let favoriteButton = FavoriteButton()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        [currencyLabel, countryLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [labelStackView, rateLabel, favoriteButton].forEach {
            contentView.addSubview($0)
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView).offset(16)
            $0.width.equalTo(120)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(rateLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(currency: Currency) {
        currencyLabel.text = currency.code
        countryLabel.text = currency.country
        rateLabel.text = "\(String(format: "%.4f", currency.rate)) \(currency.rateIcon)" // 소수점 4자리까지 표시
        
        favoriteButton.currency = currency
        favoriteButton.setButtonImage()
    }
}
