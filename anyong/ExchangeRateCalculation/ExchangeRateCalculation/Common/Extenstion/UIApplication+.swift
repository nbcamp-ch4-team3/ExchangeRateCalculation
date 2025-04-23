//
//  UIApplication+.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/23/25.
//

import UIKit

extension UIApplication {
    var activeKeyWindow: UIWindow? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: \.isKeyWindow)
    }
    
    var topViewController: UIViewController? {
        guard let root = self.activeKeyWindow?.rootViewController else { return nil }
        return Self.getTopViewController(from: root)
    }

    private static func getTopViewController(from vc: UIViewController) -> UIViewController {
        if let nav = vc as? UINavigationController {
            return getTopViewController(from: nav.visibleViewController ?? nav)
        } else if let tab = vc as? UITabBarController {
            return getTopViewController(from: tab.selectedViewController ?? tab)
        } else if let presented = vc.presentedViewController {
            return getTopViewController(from: presented)
        } else {
            return vc
        }
    }
}
