//
//  ProfileViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import Foundation

final class ProfileViewModel {
    weak var coordinator: ProfileCoordinator?
    
    private let getUserDataUseCase: GetUserDataUseCase
    
    var userData = UserData()
    
    var onDidLoadUserData: ((UserData) -> Void)?
    
    
    init() {
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
    }
    
    func onDidLoad() {
        Task {
            do {
                userData = try await fetchUserData()
                UserDefaults.standard.set(userData.isConfirmed, forKey: "isConfirmed")
                onDidLoadUserData?(userData)
            } catch {
            }
        }
    }
    

    
    private func fetchUserData() async throws -> UserData {
        do {
            let userDataResponse = try await getUserDataUseCase.execute()
            return mapToUserData(userDataResponse)
        } catch {
            throw error
        }
    }
    
    private func mapToUserData(_ userDataResponse: UserModel) -> UserData {
        return UserData(
            id: userDataResponse.id,
            isConfirmed: userDataResponse.isConfirmed,
            name: userDataResponse.name,
            group: userDataResponse.group,
            roles: userDataResponse.roles
        )
    }
    
    func logout() {
        coordinator?.logout()
    }
}
