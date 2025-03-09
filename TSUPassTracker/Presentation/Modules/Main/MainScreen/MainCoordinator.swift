//
//  MainCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit

final class MainScreenCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let viewModel = MainScreenViewModel()
        let vc = MainScreenViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: animated)
    }

}
