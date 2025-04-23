//
//  SceneDelegate.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let lastSceneDataService = LastSceneDataStorageService()
    
    var window: UIWindow?
        
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let networkService = NetworkService()
        let currencyCodeStorage = CurrencyCodeStorageService()
        let updateDateStorage = UpdateDateStorageService()
        
        let exchangeRateViewModel = ExchangeRateViewModel(
            networkService: networkService,
            currencyCodeStorage: currencyCodeStorage,
            updateDateStorage: updateDateStorage
        )
        
        guard let lastSceneData = lastSceneDataService.fetchLastScene() else {
            let vc = ExchangeRateViewController(viewModel: exchangeRateViewModel)
            
            window?.rootViewController = UINavigationController(rootViewController: vc)
            window?.makeKeyAndVisible()
            return
        }
        
        print(lastSceneData)
        
        if lastSceneData.scene == SceneType.calculator {
            let rate = currencyCodeStorage.fetchData(lastSceneData.code ?? "Error")?.exchangeRate
            let vc = ExchangeRateViewController(viewModel: exchangeRateViewModel)
            let calcVC = CalculatorViewController(exchangeRate: .init(
                currencyCode: lastSceneData.code ?? "Error",
                rate: rate ?? 0.0,
                nation: ExchangeRateDTO.mapping[lastSceneData.code ?? "Error"] ?? "Error"
            )
            )
            
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()

            DispatchQueue.main.async {
                nav.pushViewController(calcVC, animated: true)
            }
        } else if lastSceneData.scene == SceneType.main {
            
            exchangeRateViewModel.action?(.setState(text: lastSceneData.searchText ?? ""))
            let vc = ExchangeRateViewController(viewModel: exchangeRateViewModel)
            window?.rootViewController = UINavigationController(rootViewController: vc)
            window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        guard let topVC = UIApplication.shared.topViewController else { return }
        
        if let calcVC = topVC as? CalculatorViewController {
            let state = calcVC.getState()
            
            guard let code = state["code"] else { return }
            lastSceneDataService.saveLastScene(SceneType.calculator, nil, code)
        } else if let mainVC = topVC as? ExchangeRateViewController {
            let state = mainVC.getState()
            
            guard let text = state["searchText"] else { return }
            lastSceneDataService.saveLastScene(SceneType.main, text, nil)
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
