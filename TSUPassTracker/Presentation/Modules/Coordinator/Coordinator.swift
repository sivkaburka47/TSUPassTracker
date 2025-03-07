//
//  Coordinator.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start(animated: Bool)
}

protocol ParentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func addChild(_ child: Coordinator)
    func childDidFinish(_ child: Coordinator?)
}

protocol ChildCoordinator: Coordinator {
    var parentCoordinator: ParentCoordinator? { get set }
}

extension ParentCoordinator {
    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators.removeAll { $0 === child }
    }
}
