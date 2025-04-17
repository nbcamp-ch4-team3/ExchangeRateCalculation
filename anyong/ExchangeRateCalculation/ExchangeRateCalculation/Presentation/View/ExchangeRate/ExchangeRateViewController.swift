//
//  ExchangeRateViewController.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/14/25.
//

import UIKit

final class ExchangeRateViewController: UIViewController {
    private let networkService = NetworkService()
    private let rootView = ExchangeRateView()
    private var exchangeRates: [ExchangeRate] = []
    private var searchRates: [ExchangeRate] = []
    private var isSearching: Bool = false
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.tableViewConfigure(delegate: self, dataSource: self)
        rootView.searchBarConfigure(delegate: self)
        setNavigationBar()
        fetchData()
    }

    private func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                self.exchangeRates = try await self.networkService.getExchangeRate(nation: "USD").toModel()
                
                await MainActor.run {
                    self.rootView.tableViewReloadData()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.showErrorAlert(message: error.description)
                }
            } catch {
                await MainActor.run {
                    self.showErrorAlert(message: error.localizedDescription)
                }
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
        let exchangeRate = isSearching ? searchRates[indexPath.row] : exchangeRates[indexPath.row]
        let vc = ExchangeRateCalculatorViewController(exchangeRate: exchangeRate)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchRates.count : exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeRateCell.identifier,
            for: indexPath
        ) as? ExchangeRateCell else { return UITableViewCell() }
        
        if isSearching {
            cell.configure(searchRates[indexPath.row])
        } else {
            cell.configure(exchangeRates[indexPath.row])
        }
        return cell
    }
}


extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchRates = []
            isSearching = false
            rootView.tableViewReloadData()
        } else {
            isSearching = true
            searchExchangeRate(searchText)
            rootView.tableViewReloadData()
            
            if searchRates.isEmpty {
                rootView.updateBackgroundView(true)
            } else {
                rootView.updateBackgroundView(false)
            }
        }
    }
    
    private func searchExchangeRate(_ text: String) {
        if text.isHangul {
            searchRates = exchangeRates.filter { $0.nation.contains(text) }
        } else {
            searchRates = exchangeRates.filter { $0.currencyCode.contains(text.uppercased()) }
        }
    }
}
