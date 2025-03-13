//
//  MainCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class MainTabBarCoordinator: ParentCoordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let authService: AuthServiceProtocol
    private var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.authService = authService
        setupTabBarAppearance()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUnauthorizedError),
            name: .unauthorizedErrorOccurred,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .unauthorizedErrorOccurred, object: nil)
    }
    
    func start(animated: Bool) {
        setupTabs()
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.isNavigationBarHidden = true
    }
    
    private func setupTabs() {
        tabBarController.viewControllers = [
            createMainFlow(),
            createProfileFlow()
        ]
    }
    
    private func createMainFlow() -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate),
            tag: 0
        )
        let coordinator = MainScreenCoordinator(navigationController: nav)
        coordinator.parentCoordinator = self
        addChild(coordinator)
        coordinator.start(animated: false)
        return nav
    }
    
    private func createProfileFlow() -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate),
            tag: 2
        )
        let coordinator = ProfileCoordinator(navigationController: nav, authService: authService)
        coordinator.parentCoordinator = self
        addChild(coordinator)
        coordinator.start(animated: false)
        return nav
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarController.tabBar.layer.shadowOpacity = 0.1
        tabBarController.tabBar.layer.shadowRadius = 4
    }
    
    @objc private func handleUnauthorizedError() {
        navigationController.dismiss(animated: false)
        authService.logout()
        parentCoordinator?.childDidFinish(self)
        
        if let rootCoordinator = parentCoordinator as? RootCoordinator {
            rootCoordinator.startAuthFlow()
        }
    }
    
    
}
