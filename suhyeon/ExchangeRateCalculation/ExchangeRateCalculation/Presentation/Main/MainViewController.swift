//
//  MainViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import UIKit
import os

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(title: "환율 정보", isLargeTitle: true)
        setProtocol()
        view = mainView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.action?(.loadExchangeRates)

        viewModel.state.updateExchangeRates = {[weak self] in
            guard let self else { return }

            let dataSource = viewModel.state.exchangeRates
            self.mainView.setEmptyStateVisible(dataSource.isEmpty)

            self.mainView.tableView.reloadData()
        }

        viewModel.state.handleNetworkError = {[weak self] error in
            self?.showErrorAlert(
                title: "네트워크 오류",
                message: error.localizedDescription
            )
            os_log("%@", type: .error, error.debugDescription)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.state.exchangeRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let dataSource = viewModel.state.exchangeRates
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = viewModel.state.exchangeRates
        let nextVC = ExchangeRateCalculatorViewController(exchangeRate: dataSource[indexPath.row])
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.filterExchangeRates(searchText))
    }
}

private extension MainViewController {
    private func setProtocol() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.searchBar.delegate = self
    }
}
