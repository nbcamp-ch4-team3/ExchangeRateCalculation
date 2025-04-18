//
//  UIViewController+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

enum AlertType: String {
    case networkError = "네트워크 오류"
    case defaultError = "오류"
}

extension UIViewController {
    func showErrorAlert(type: AlertType, message: String?) {
        let alertController = UIAlertController(
            title: type.rawValue,
            message: message,
            preferredStyle: .alert
        )
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
