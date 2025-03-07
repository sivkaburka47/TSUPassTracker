//
//  SignUpViewModel.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import Foundation

protocol SignUpViewModelProtocol {
    var onSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    func updateName(_ name: String)
    func updateSurname(_ surname: String)
    func updateMiddlename(_ middlename: String)
    func updateGroup(_ group: String)
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    func updateRepeatedPassword(_ password: String)
    func signUpButtonTapped()
}

final class SignUpViewModel: SignUpViewModelProtocol {
    weak var coordinator: AuthCoordinator?
    private let authService: AuthServiceProtocol
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let signUpUseCase: SignUpUseCase
    
    
    var credentials = RegisterCredentials()
    
    var isNameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isSurnameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isMiddlenameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isGroupValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isUsernameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isPasswordValid: Bool = false {
        didSet {
            validateRepeatedPassword()
            validateFields()
        }
    }
    var isRepeatedPasswordValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    
    var isSignUpButtonActive: ((Bool) -> Void)?
    
    init(authService: AuthServiceProtocol, coordinator: AuthCoordinator?) {
        self.authService = authService
        self.coordinator = coordinator
        self.signUpUseCase = SignUpUseCaseImpl.create()
    }
    
    func updateName(_ name: String) {
        self.credentials.name = name
        isNameValid = !name.isEmpty
        validateFields()
    }
    
    func updateSurname(_ surname: String) {
        self.credentials.surname = surname
        isSurnameValid = !surname.isEmpty
        validateFields()
    }
    
    func updateMiddlename(_ middlename: String) {
        self.credentials.username = middlename
        isMiddlenameValid = !middlename.isEmpty
        validateFields()
    }
    
    func updateGroup(_ group: String) {
        self.credentials.group = group
        isGroupValid = !group.isEmpty
        validateFields()
    }
    
    func updateUsername(_ username: String) {
        self.credentials.username = username
        isUsernameValid = isValidLatinCharacters(username) && !username.isEmpty
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.credentials.password = password
        isPasswordValid = isValidLatinCharacters(password) && !password.isEmpty
        validateRepeatedPassword()
        validateFields()
    }
    
    func updateRepeatedPassword(_ repeatedPassword: String) {
        self.credentials.repeatedPassword = repeatedPassword
        isRepeatedPasswordValid = (repeatedPassword == credentials.password)
        validateRepeatedPassword()
        validateFields()
    }
    
    func signUpButtonTapped()  {
        Task {
            let requestBody = UserRegisterModel(
                name: "\(credentials.surname) \(credentials.name) \(credentials.middlename)",
                login: credentials.username,
                password: credentials.password,
                group: credentials.group
            )
            
            do {
                try await signUpUseCase.execute(request: requestBody)
                DispatchQueue.main.async {
                    self.onSuccess?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func validateRepeatedPassword() {
        isRepeatedPasswordValid = (credentials.repeatedPassword == credentials.password)
    }
    
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
    
    private func validateFields() {
        let isValid = isNameValid && isSurnameValid && isMiddlenameValid && isGroupValid && isUsernameValid && isPasswordValid && isRepeatedPasswordValid
        isSignUpButtonActive?(isValid)
    }
}
