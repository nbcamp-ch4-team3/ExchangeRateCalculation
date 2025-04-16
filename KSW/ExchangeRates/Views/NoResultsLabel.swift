//
//  NoResultsLabel.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/16/25.
//

import UIKit

// 사용자가 검색할 때, 검색 결과 없음 표시 레이블
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
