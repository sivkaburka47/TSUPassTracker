//
//  SignInViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import Foundation

protocol SignInViewModelProtocol {
    var onSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onSignUp: (() -> Void)? { get set }
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    func signInButtonTapped()
}

final class SignInViewModel: SignInViewModelProtocol {
    weak var coordinator: AuthCoordinator?
    private let authService: AuthServiceProtocol
    
    private let signInUseCase: SignInUseCase
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onSignUp: (() -> Void)?
    
    
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
    
    var isSignInButtonActive: ((Bool) -> Void)?
    
    init(authService: AuthServiceProtocol, coordinator: AuthCoordinator?) {
        self.authService = authService
        self.coordinator = coordinator
        self.signInUseCase = SignInUseCaseImpl.create()
    }
    
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
    
    func signInButtonTapped() {
        Task {
            let requestBody = LoginCredentialsRequestModel(
                login: credentials.username,
                password: credentials.password
            )
            
            do {
                try await signInUseCase.execute(request: requestBody)
                DispatchQueue.main.async {
                    self.onSuccess?()
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func navigateSignUpButtonTapped() {
        onSignUp?()
    }
    
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
