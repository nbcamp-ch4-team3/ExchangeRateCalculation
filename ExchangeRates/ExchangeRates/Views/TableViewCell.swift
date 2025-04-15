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
    
    // 통화 기호(예: USD)
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // 환율(예: 1.000)
    private let currencyRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [currencyCodeLabel, currencyRateLabel].forEach {
            addSubview($0)
        }
        
        currencyCodeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        currencyRateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(currencyCode: String, currencyRate: Double) {
        currencyCodeLabel.text = currencyCode
        currencyRateLabel.text = String(format: "%.4f", currencyRate) // 소수점 4자리까지 표시
    }
}
