//
//  ProfileViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import Foundation

final class ProfileViewModel {
    weak var coordinator: ProfileCoordinator?
    
    func logout() {
        coordinator?.logout()
    }
}

