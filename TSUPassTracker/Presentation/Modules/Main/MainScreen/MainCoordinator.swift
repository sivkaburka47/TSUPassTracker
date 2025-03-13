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
        viewModel.showAddRequest = { [weak self] in self?.showAddRequest() }
        let vc = MainScreenViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: animated)
    }
    
    func showAddRequest() {
        let addNav = UINavigationController()
        let coordinator = AddRequestCoordinator(navigationController: addNav)
        coordinator.parentCoordinator = self.parentCoordinator
        parentCoordinator?.addChild(coordinator)
        
        if let presentingVC = navigationController.topViewController {
            coordinator.start(animated: true)
            presentingVC.present(addNav, animated: true)
        }
    }

}
