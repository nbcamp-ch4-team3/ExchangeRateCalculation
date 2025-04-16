import UIKit

extension UIView {
    func addSubViews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
