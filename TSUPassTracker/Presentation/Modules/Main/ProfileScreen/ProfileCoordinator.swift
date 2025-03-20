//
//  ProfileCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit

final class ProfileCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let authService: AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start(animated: Bool) {
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func logout() {
        authService.logout()
        parentCoordinator?.childDidFinish(self)
        if let mainTabBarCoordinator = parentCoordinator as? MainTabBarCoordinator,
           let rootCoordinator = mainTabBarCoordinator.parentCoordinator as? RootCoordinator {
            rootCoordinator.startAuthFlow()
        }
    }
    
    @objc private func handleUnauthorizedError() {
        logout()
    }
}
