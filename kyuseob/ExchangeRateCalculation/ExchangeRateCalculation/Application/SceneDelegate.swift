//
//  SceneDelegate.swift
//  ExchangeRateCalculation
//
//  Created by 송규섭 on 4/15/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground

        let viewModel = MainViewModel(service: DataService())
//        let viewModel = MainViewModel(service: MockDataService()) // 일부 통화가 저장되어 있는 목데이터
        let mainNavigationController = UINavigationController(
            rootViewController: MainViewController(viewModel: viewModel)
        )
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()

        if let lastPage = CoreDataStack.shared.fetchLastPage(),
           let identifier = lastPage.identifier,
           let params = lastPage.getParams() {
            restoreLastState(identifier: identifier, params: params, navigationController: mainNavigationController)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else { return }

        if let currentVC = getCurrentViewController(from: rootVC) as? StateSavable {
            let identifier = currentVC.identifier
            let params = currentVC.getStateParams()
            CoreDataStack.shared.saveLastPage(identifier: identifier, params: params)
        }
        CoreDataStack.shared.saveContext()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else { return }

        if let currentVC = getCurrentViewController(from: rootVC) as? StateSavable {
            let identifier = currentVC.identifier
            let params = currentVC.getStateParams()
            CoreDataStack.shared.saveLastPage(identifier: identifier, params: params)
        }
    }

    private func getCurrentViewController(from rootVC: UIViewController) -> UIViewController {
        if let tabBarController = rootVC as? UITabBarController,
           let selectedVC = tabBarController.selectedViewController {
            return getCurrentViewController(from: selectedVC)
        }

        if let navigationController = rootVC as? UINavigationController,
           let visibleVC = navigationController.visibleViewController {
            return getCurrentViewController(from: visibleVC)
        }

        if let presentedVC = rootVC.presentedViewController {
            return getCurrentViewController(from: presentedVC)
        }

        return rootVC
    }

    private func restoreLastState(identifier: String, params: [String: Any]?, navigationController: UINavigationController) {
        let viewController = createViewController(with: identifier, params: params)

        if let viewController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 초기 뷰컨트롤러 로드할 시간을 줄 수 있도록 지연 시간을 추가
                navigationController.pushViewController(viewController, animated: false)
            }
        }
    }

    private func createViewController(with identifier: String, params: [String: Any]?) -> UIViewController? {
        switch identifier {
        case "MainVC":
            if let navController = window?.rootViewController as? UINavigationController,
               let mainVC = navController.viewControllers.first as? MainViewController {
                DispatchQueue.main.async {
                    mainVC.restoreState(with: params)
                }
            }
            return nil
        case "CalculatorVC":
            let viewModel = CalculatorViewModel()
            let viewController = CalculatorViewController(viewModel: viewModel)
            viewController.restoreState(with: params)

            return viewController
        default:
            return nil
        }
    }
}

