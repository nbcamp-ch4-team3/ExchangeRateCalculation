//
//  ViewController.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/14/25.
//

import UIKit

class ViewController: UIViewController {
    private let networkService = NetworkService()
    private let rootView = ExchangeRateView()
    private var exchangeRates: [ExchangeRate] = []
    private var searchRates: [ExchangeRate] = []
    private var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.tableViewConfigure(delegate: self, dataSource: self)
        rootView.searchBarConfigure(delegate: self)
        fetchData()
    }
    
    override func loadView() {
        view = rootView
    }

    private func fetchData() {
        Task {
            do {
                exchangeRates = try await networkService.getExchangeRate(nation: "USD").toModel()
                
                await MainActor.run {
                    rootView.tableViewReloadData()
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    showErrorAlert(message: error.description)
                }
            } catch {
                await MainActor.run {
                    showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "🚨 에러 🚨", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
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


extension ViewController: UISearchBarDelegate {
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
