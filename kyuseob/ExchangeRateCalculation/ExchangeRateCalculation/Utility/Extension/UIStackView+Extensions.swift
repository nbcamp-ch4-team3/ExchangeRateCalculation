import UIKit

extension UIStackView {
    func addArrangedSubViews(views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
