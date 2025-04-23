//
//  MainViewController.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import UIKit
import os

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel: MainViewModel
    private var isFirstAppear = true

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        view = mainView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            bindViewModel()
            isFirstAppear = false
            return
        }

        viewModel.action?(.saveLastScreen(screen: .main, exchangeRate: nil))
    }

    private func bindViewModel() {
        viewModel.state.navigateToCalculator = {[weak self] exchangeRate in
            guard let self else { return }
            self.navigateToCalculator(with: exchangeRate)
        }

        viewModel.state.updateExchangeRates = {[weak self] in
            guard let self else { return }

            let dataSource = viewModel.state.exchangeRates
            self.mainView.setEmptyStateVisible(dataSource.isEmpty)

            self.mainView.reloadTableView()
        }

        viewModel.state.handleError = { [weak self] error in
            self?.showErrorAlert(
                type: error.alertType,
                message: error.localizedDescription
            )
            os_log("%@", type: .error, error.debugDescription)
        }

        viewModel.action?(.restoreLastVisitedScreen)
        viewModel.action?(.loadExchangeRates)

    }

    private func navigateToCalculator(with exchangeRate: ExchangeRate) {
        viewModel.action?(.saveLastScreen(screen: .calculator, exchangeRate: exchangeRate))
        let nextVC = CalculatorViewController(exchangeRate: exchangeRate)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
// UITableViewDataSource
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
        cell.delegate = self
        return cell
    }
}

// UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = viewModel.state.exchangeRates
        navigateToCalculator(with: dataSource[indexPath.row])
    }
}

// UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.filterExchangeRates(searchText))
    }
}

// ExchangeRateCellDelegate
extension MainViewController: ExchangeRateCellDelegate {
    func didTapStarButton(with currency: String) {
        viewModel.action?(.toggleFavoriteItem(currency: currency))
    }
}

// Configure
private extension MainViewController {
    private func configure() {
        setNavigationBar(title: "환율 정보", isLargeTitle: true)
        setProtocol()
    }

    private func setProtocol() {
        mainView.setSearchBarDelegate(delegate: self)
        mainView.setTableViewDelegateAndDataSource(
            delegate: self,
            dataSource: self
        )
    }
}
