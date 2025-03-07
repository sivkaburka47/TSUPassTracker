//
//  SignUpCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit

final class SignUpCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let authService: AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start(animated: Bool) {
        let viewModel = SignUpViewModel(
            authService: authService,
            coordinator: parentCoordinator as? AuthCoordinator
        )
        let vc = SignUpViewController(viewModel: viewModel)
        viewModel.onSuccess = { [weak self] in self?.handleSuccess() }
        configureScreen(vc, title: "Авторизация", showBackButton: true)
        navigationController.pushViewController(vc, animated: animated)
    }
    
    private func configureScreen(_ vc: UIViewController, title: String, showBackButton: Bool) {
        
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.tintColor = .label
        vc.hidesBottomBarWhenPushed = true
        
        
        if showBackButton {
            let backButton = UIButton(type: .system)
            backButton.backgroundColor = .clear
            backButton.layer.cornerRadius = 20
            backButton.setImage(UIImage(systemName: "arrow.left")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
            backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
            
            let containerView = UIView()
            containerView.addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.size.equalTo(40)
                make.edges.equalToSuperview()
            }
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            titleLabel.textColor = .black
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 16
            let backBarButtonItem = UIBarButtonItem(customView: containerView)
            vc.navigationItem.leftBarButtonItems = [
                backBarButtonItem,
                spacer,
                UIBarButtonItem(customView: titleLabel)
            ]
        } else {
            vc.navigationItem.backButtonTitle = title
        }
        vc.navigationController?.navigationBar.isHidden = false
    
    }
    
    @objc private func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
    
    private func handleSuccess() {
        (parentCoordinator as? AuthCoordinator)?.authComplete()
    }
}
