//
//  SignInCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit

final class SignInCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let authService: AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start(animated: Bool) {
        let viewModel = SignInViewModel(
            authService: authService,
            coordinator: parentCoordinator as? AuthCoordinator
        )
        let vc = SignInViewController(viewModel: viewModel)
        viewModel.onSuccess = { [weak self] in self?.handleSuccess() }
        viewModel.onSignUp = { [weak self] in self?.showSignUp() }
        navigationController.pushViewController(vc, animated: animated)
    }
    
    private func handleSuccess() {
        (parentCoordinator as? AuthCoordinator)?.authComplete()
    }
    
    private func showSignUp() {
        (parentCoordinator as? AuthCoordinator)?.showSignUp()
    }
}
