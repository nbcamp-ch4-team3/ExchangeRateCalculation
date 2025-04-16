//
//  ExchangeRateView.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import UIKit

import SnapKit
import Then

final class ExchangeRateView: UIView {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        searchBar.do {
            $0.placeholder = "통화 검색"
            $0.backgroundImage = UIImage()
        }
        
        tableView.do {
            $0.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier)
            $0.separatorStyle = .singleLine
            $0.rowHeight = 60
        }
    }
    
    private func setUI() {
        addsubViews(searchBar, tableView)
    }
    
    private func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
