//
//  DetailViewController.swift
//  ExchangeRates
//
//  Created by 권순욱 on 4/16/25.
//

import UIKit

class DetailViewController: UIViewController {
    let exchangeRate: ExchangeRate
    
    private let detailView = DetailView()
    
    override func loadView() {
        super.loadView()
        
        view = detailView
    }
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "환율 계산기"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        detailView.currencyLabel.text = exchangeRate.code
        detailView.countryLabel.text = exchangeRate.country
    }
}
