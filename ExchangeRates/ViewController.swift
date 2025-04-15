//
//  ViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/15/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var exchangeRates: [String: Double] = [:] {
        didSet {
            let sortedExchangeRates = exchangeRates.sorted { $0.key < $1.key }
            currencyCodes = sortedExchangeRates.map { $0.key }
            currencyRates = sortedExchangeRates.map { $0.value }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var currencyCodes: [String] = []
    private var currencyRates: [Double] = []
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetch()
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
    
    func fetch() {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else { return }
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                DispatchQueue.main.async {
                    self.showError(error!)
                }
                return
            }
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(ExchangeRate.self, from: data) else {
                    print("JSON 디코딩 실패")
                    return
                }
                for (key, value) in decodedData.rates {
                    self.exchangeRates.updateValue(value, forKey: key)
                }
            } else {
                print("응답 오류")
            }
        }
        task.resume()
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let currencyCode = currencyCodes[indexPath.row]
        let currencyRate = currencyRates[indexPath.row]
        cell.configureUI(currencyCode: currencyCode, currencyRate: currencyRate)
        
        return cell
    }
}
