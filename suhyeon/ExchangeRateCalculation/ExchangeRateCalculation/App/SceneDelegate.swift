//
//  SceneDelegate.swift
//  ExchangeRateCalculation
//
//  Created by 이수현 on 4/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coreData = LastScreenCoreData(container: appDelegate.persistentContainer)
        let lastScreenRepository = LastScreenRepository(coreData: coreData)
        let mainViewModel = MainViewModel(repository: lastScreenRepository)
        let mainVC = MainViewController(viewModel: mainViewModel)
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()
    }
}

