//
//  EmptyView.swift
//  ExchangeRateCalculation
//
//  Created by 송규섭 on 4/16/25.
//

import UIKit

class EmptyView: UIView {
    private let emptyStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "검색 결과가 없습니다."

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}

extension EmptyView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        addSubViews(views: emptyStatusLabel)
    }

    func setConstraints() {
        emptyStatusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
