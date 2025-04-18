//
//  ExchangeRateViewController.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/14/25.
//

import UIKit

final class ExchangeRateViewController: UIViewController {
    private let rootView = ExchangeRateView()
    private let viewModel: ExchangeRateViewModel
    
    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.tableViewConfigure(delegate: self, dataSource: self)
        rootView.searchBarConfigure(delegate: self)
        setNavigationBar()
        bind()
        viewModel.action?(.fetch)
    }
    
    private func bind() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            
            if let message = state.errorMessage {
                DispatchQueue.main.async {
                    self.showErrorAlert(message: message)
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.rootView.updateBackgroundView(state.isSearching && state.searchRates.isEmpty)
                self.rootView.tableViewReloadData()
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "🚨 에러 🚨", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "환율 정보"
        self.navigationItem.backButtonTitle = "환율 정보"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exchangeRate: ExchangeRate
        
        if viewModel.state.isSearching {
            exchangeRate = viewModel.state.searchRates[indexPath.row]
        } else {
            exchangeRate = viewModel.state.exchangeRates[indexPath.row]
        }
                
        let vc = CalculatorViewController(exchangeRate: exchangeRate)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.state.isSearching {
            viewModel.state.searchRates.count
        }  else {
            viewModel.state.exchangeRates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeRateCell.identifier,
            for: indexPath
        ) as? ExchangeRateCell else { return UITableViewCell() }
        
        let exchangeRate: ExchangeRate
        
        if viewModel.state.isSearching {
            exchangeRate = viewModel.state.searchRates[indexPath.row]
        } else {
            exchangeRate = viewModel.state.exchangeRates[indexPath.row]
        }
        
        cell.configure(
            currencyCode: exchangeRate.currencyCode,
            nation: exchangeRate.nation,
            rate: exchangeRate.rate
        )
        
        return cell
    }
}


extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.search(text: searchText))
    }
}
