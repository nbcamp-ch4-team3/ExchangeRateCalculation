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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = rootView
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        fetchData()
    }

    private func fetchData() {
        Task {
            do {
                exchangeRates = try await networkService.getExchangeRate(nation: "USD").toModel()
                
                await MainActor.run {
                    rootView.tableView.reloadData()
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
        print(exchangeRates.count)
        return exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExchangeRateCell.identifier,
            for: indexPath
        ) as? ExchangeRateCell else { return UITableViewCell() }
        cell.configure(exchangeRates[indexPath.row])
        return cell
    }
}
