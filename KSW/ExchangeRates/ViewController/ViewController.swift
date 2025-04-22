//
//  ViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let tableView = UITableView()
    
    private let viewModel: ViewModel
    private let noResultsLabel = NoResultsLabel() // 사용자의 검색 결과가 없을 때
    
    init() {
        self.viewModel = ViewModel()
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        viewModel.loadCurrencies()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "환율 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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

// MARK: - View Model Delegate
extension ViewController: ViewModelDelegate {
    func viewModelDidLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func viewModel(didFailWithError error: any Error) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }
    
    func viewModelDidFilterData() {
        // 검색 결과가 없으면 검색 결과 없음 레이블 표시
        DispatchQueue.main.async {
            if self.viewModel.filteredCurrencies.isEmpty {
                self.tableView.backgroundView = self.noResultsLabel
            } else {
                self.tableView.backgroundView = nil
            }
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table View DataSource, Delegate
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.configureUI(currency: viewModel.filteredCurrencies[indexPath.row])
        
        cell.favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        return cell
    }
    
    @objc func toggleFavorite(_ sender: FavoriteButton) {
        guard let currency = sender.currency else { return }
        viewModel.toggleFavorite(currency)
        
        sender.setButtonImage()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = viewModel.filteredCurrencies[indexPath.row]
        
        let viewModel = DetailViewModel(currency: currency)
        let viewController = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Search Bar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCurrencies(searchText: searchText)
    }
}
