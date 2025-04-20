//
//  FavoriteButton.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/18/25.
//

import UIKit
import SnapKit

// 즐겨찾기 추가/삭제
class FavoriteButton: UIButton {
    var currency: Currency?
    
    init(currency: Currency? = nil) {
        self.currency = currency
        super.init(frame: .zero)
        
        tintColor = .systemYellow
        
        setButtonImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonImage() {
        if let currency, currency.isFavorite {
            setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
