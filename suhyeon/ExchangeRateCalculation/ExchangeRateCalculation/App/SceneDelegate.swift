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
        let lastScreenCoreData = LastScreenCoreData(container: appDelegate.persistentContainer)
        let lastScreenRepository = LastScreenRepository(coreData: lastScreenCoreData)
        let lastScreenUseCase = LastScreenUseCase(repository: lastScreenRepository)

        let exchangeRateCoreData = ExchangeRateCoreData(container: appDelegate.persistentContainer)
        let exchangeRateRepository = ExchangeRateRepository(networkService: NetworkService(), coreData: exchangeRateCoreData)
        let exchangeRateUseCase = ExchangeRateUseCase(repository: exchangeRateRepository)

        let mainViewModel = MainViewModel(lastScreenUseCase: lastScreenUseCase, exchangeRateUseCase: exchangeRateUseCase)
        let mainVC = MainViewController(viewModel: mainViewModel)
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()
    }
}

