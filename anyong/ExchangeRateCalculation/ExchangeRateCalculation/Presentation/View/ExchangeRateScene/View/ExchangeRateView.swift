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
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
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

extension ExchangeRateView {
    func tableViewConfigure(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func searchBarConfigure(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func tableViewReloadData() {
        tableView.reloadData()
    }
    
    func updateBackgroundView(_ isEmpty: Bool) {
        if isEmpty {
            let label = UILabel()
            
            label.do {
                $0.text = "검색 결과 없음"
                $0.textColor = .systemGray
                $0.font = .systemFont(ofSize: 16, weight: .medium)
                $0.textAlignment = .center
            }
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
}
