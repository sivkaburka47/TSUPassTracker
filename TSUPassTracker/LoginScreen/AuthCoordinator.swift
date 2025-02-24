//
//  AuthCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didAuthenticate()
}

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    weak var delegate: AuthCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    func start() {
        let viewModel = LoginViewModel()
        viewModel.coordinator = self
        let vc = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func completeAuthentication() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        delegate?.didAuthenticate()
    }
}

