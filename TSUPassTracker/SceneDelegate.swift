//
//  SceneDelegate.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
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
    }


}

