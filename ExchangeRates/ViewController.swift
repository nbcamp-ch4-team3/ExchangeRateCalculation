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
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        loadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataManager.exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let currencyCode = dataManager.currencyCodes[indexPath.row]
        let currencyRate = dataManager.currencyRates[indexPath.row]
        cell.configureUI(currencyCode: currencyCode, currencyRate: currencyRate)
        
        return cell
    }
}
