//
//  UIViewController+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true)
    }

    func setNavigationBar(title: String, isLargeTitle: Bool) {
        navigationItem.title = title
        navigationItem.backButtonTitle = title

        navigationController?.navigationBar.prefersLargeTitles = isLargeTitle
    }
}
