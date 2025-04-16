import UIKit

extension UIViewController {
    func showAlert(
        title: String = "알림",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        confirmTitle: String = "확인",
        confirmStyle: UIAlertAction.Style = .default,
        confirmHandler: (() -> Void)? = nil,
        cancelTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmHandler?()
        }
        alert.addAction(confirmAction)

        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(
                title: cancelTitle,
                style: .cancel) { _ in
                    cancelHandler?()
                }
            alert.addAction(cancelAction)
        }

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
