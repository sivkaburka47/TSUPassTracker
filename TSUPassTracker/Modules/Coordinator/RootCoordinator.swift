//
//  AppCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class RootCoordinator: ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let authService: AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start(animated: Bool) {
        authService.isAuthenticated ? startMainFlow() : startAuthFlow()
    }
    
    func startAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            authService: authService
        )
        authCoordinator.parentCoordinator = self
        addChild(authCoordinator)
        authCoordinator.start(animated: true)
    }
    
    func startMainFlow() {
        let mainCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            authService: authService
        )
        mainCoordinator.parentCoordinator = self
        addChild(mainCoordinator)
        mainCoordinator.start(animated: true)
    }
}
