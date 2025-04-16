//
//  UIViewController+Extensions.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/15/25.
//

import UIKit

extension UIViewController {
    func showNetworkErrorAlert(message: String?) {
        let alertController = UIAlertController(title: "네트워크 오류", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true)
    }
}
