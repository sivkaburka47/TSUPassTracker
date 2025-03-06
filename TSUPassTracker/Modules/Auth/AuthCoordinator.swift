//
//  AuthCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit

final class AuthCoordinator: ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let authService: AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start(animated: Bool) {
        showSignIn()
    }
    
    private func showSignIn() {
        let coordinator = SignInCoordinator(
            navigationController: navigationController,
            authService: authService
        )
        coordinator.parentCoordinator = self
        addChild(coordinator)
        coordinator.start(animated: true)
    }
    
    func showSignUp() {
        let coordinator = SignUpCoordinator(
            navigationController: navigationController,
            authService: authService
        )
        coordinator.parentCoordinator = self
        addChild(coordinator)
        coordinator.start(animated: true)
    }
    
    
    
    func authComplete() {
        parentCoordinator?.childDidFinish(self)
        (parentCoordinator as? RootCoordinator)?.startMainFlow()
    }
}
