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
        let mockDateService = MockDataService() // 일부 통화가 저장되어 있는 목데이터
        let dataService = DataService()
        let mainNavigationController = UINavigationController(
            rootViewController: MainViewController(viewModel: MainViewModel(service: mockDateService))
        )
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.saveContext()
    }


}

