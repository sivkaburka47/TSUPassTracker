//
//  LoginViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import Foundation

final class LoginViewModel {
    weak var coordinator: AuthCoordinator?
    
    func handleLogin() {
        coordinator?.completeAuthentication()
    }
}
