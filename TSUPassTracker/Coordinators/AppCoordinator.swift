//
//  AppCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    
    func start() {
        if isUserLoggedIn {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let welcomeCoordinator = AuthCoordinator(navigationController: navigationController)
        welcomeCoordinator.parentCoordinator = self
        welcomeCoordinator.delegate = self
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showMainFlow() {
        childCoordinators.removeAll { $0 is AuthCoordinator }
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    private var isUserLoggedIn: Bool {
        return false
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didAuthenticate() {
        childCoordinators.removeAll()
        showMainFlow()
    }
}

