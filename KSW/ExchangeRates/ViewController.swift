//
//  ViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let dataManager: DataManager
    
    init() {
        self.dataManager = DataManager()
        super.init(nibName: nil, bundle: nil)
        self.dataManager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let tableView = UITableView()
    
    private let noResultsLabel = NoResultsLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        loadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadData() {
        dataManager.loadData()
    }
    
    private func showError(_ error: Error) {
        let alertTitle = NSLocalizedString("Error", comment: "Error alert title")
        let alert = UIAlertController(
            title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "Alert OK button title")
        alert.addAction(
            UIAlertAction(
                title: actionTitle, style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: DataManagerDelegate {
    func dataManagerDidLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dataManager(didFailWithError error: any Error) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }
    
    func dataManagerDidFilterData() {
        // 검색 결과가 없으면 검색 결과 없음 레이블 표시
        DispatchQueue.main.async {
            if self.dataManager.filteredExchangeRates.isEmpty {
                self.tableView.backgroundView = self.noResultsLabel
            } else {
                self.tableView.backgroundView = nil
            }
            
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataManager.filteredExchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.configureUI(exchangeRate: dataManager.filteredExchangeRates[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataManager.filterData(searchText: searchText)
    }
}
