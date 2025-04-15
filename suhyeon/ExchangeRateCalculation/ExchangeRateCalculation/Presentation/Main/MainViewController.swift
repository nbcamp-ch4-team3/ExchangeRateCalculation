//
//  MainViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import UIKit

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let networkService = NetworkService()
    private var dataSource = ExchangeRates()


    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        view = mainView

        Task {
            let result = await networkService.fetchExchangeRate()
            switch result {
            case .success(let result):
                let exchangeRates: ExchangeRates = result.rates
                    .compactMap { (currency, rate)  in
                        guard let country = countryMapping[currency] else { return nil }
                        return ExchangeRate(country: country, currency: currency, rate: rate)
                    }

                await MainActor.run {
                    dataSource = exchangeRates
                    mainView.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure.errorDescription)
                print(failure.debugDescription)
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
