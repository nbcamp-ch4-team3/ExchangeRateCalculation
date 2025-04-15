//
//  MainView.swift
//  ExchangeRateCalculation
//
//  Created by 송규섭 on 4/15/25.
//

import UIKit

class MainView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}

private extension MainView {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {

    }

    func setHierarchy() {

    }

    func setConstraints() {

    }
}
