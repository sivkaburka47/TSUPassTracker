//
//  MainCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class MainCoordinator: Coordinator {
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
        let viewModel = MainViewModel()
        viewModel.coordinator = self
        let vc = MainViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
