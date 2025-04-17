//
//  NoResultsLabel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/16/25.
//

import UIKit

// 사용자의 검색 결과가 없을 때
class NoResultsLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        text = "검색 결과 없음"
        textColor = .gray
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
