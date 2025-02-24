//
//  SignInViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import Foundation

final class SignInViewModel {
    weak var coordinator: AuthCoordinator?
    
    var isSignInButtonActive: ((Bool) -> Void)?
    
    var credentials = LoginCredentials()
    
    var isUsernameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isPasswordValid: Bool = false {
        didSet {
            validateFields()
        }
    }

    init() {
    }
    
    func handleLogin() {
        coordinator?.completeAuthentication()
    }
    
    // MARK: - Public Methods
    func updateUsername(_ username: String) {
        self.credentials.username = username
        isUsernameValid = isValidLatinCharacters(username) && !username.isEmpty
        validateFields()
    }

    func updatePassword(_ password: String) {
        self.credentials.password = password
        isPasswordValid = isValidLatinCharacters(password) && !password.isEmpty
        validateFields()
    }
    
    func signInButtonTapped() async {
        let requestBody = LoginCredentialsRequestModel(
            username: credentials.username,
            password: credentials.password
        )
        
        do {
            handleLogin()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private Methods
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
    
    private func validateFields() {
        let isValid = isUsernameValid && isPasswordValid
        isSignInButtonActive?(isValid)
    }
}

