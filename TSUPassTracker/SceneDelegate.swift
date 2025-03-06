//
//  SceneDelegate.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        let navController = UINavigationController()
        
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
        
        let authService = AuthService()
        rootCoordinator = RootCoordinator(
            navigationController: navController,
            authService: authService
        )
        rootCoordinator?.start(animated: false)
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

