//
//  AddRequestCoordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 11.03.2025.
//

import UIKit

final class AddRequestCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: ParentCoordinator?
    private let requestId: String?
    
    init(navigationController: UINavigationController, requestId: String? = nil) {
        self.navigationController = navigationController
        self.requestId = requestId
    }
    
    var onRequestCreated: (() -> Void)?
    
    func start(animated: Bool) {
        let viewModel = AddRequestViewModel(mode: requestId != nil ? .edit(requestId: requestId!) : .create)
        let vc = AddRequestViewController(viewModel: viewModel)
        vc.onDismiss = { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }
        
        navigationController.pushViewController(vc, animated: animated)
    }
}
