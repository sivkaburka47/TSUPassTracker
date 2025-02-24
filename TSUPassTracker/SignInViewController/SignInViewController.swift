//
//  SignInViewController.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class SignInViewController: UIViewController, UITextFieldDelegate {

    private var viewModel: SignInViewModel
    
    private let stackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let loginTextField = CustomTextField(style: .information(.username))
    private let passwordTextField = CustomTextField(style: .password(.password))
    
    private let signInButton = CustomButton(style: .inactive)
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
    }
}

// MARK: - Setup
private extension SignInViewController {
    func setup() {
        setupView()
        configureUI()
        addTapGestureToDismissKeyboard()
    }
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func configureUI() {
        configureTitleLabel() 
        configureStackView()
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "Авторизация"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        stackView.setCustomSpacing(20, after: titleLabel)
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: passwordTextField)
        
        configureTextFields()
        configureButton()
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureTextFields() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
    }
    
    func configureButton() {
        signInButton.setTitle("Войти", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    func updateTextFieldValidation() {
        loginTextField.layer.borderColor = viewModel.isUsernameValid ? UIColor.clear.cgColor : UIColor.white.cgColor
        loginTextField.layer.borderWidth = viewModel.isUsernameValid ? 0 : 1
        
        passwordTextField.layer.borderColor = viewModel.isPasswordValid ? UIColor.clear.cgColor : UIColor.white.cgColor
        passwordTextField.layer.borderWidth = viewModel.isPasswordValid ? 0 : 1
    }
    
    // MARK: - Actions
    @objc func signInButtonTapped() {
        Task {
            await viewModel.signInButtonTapped()
        }
    }
    
    @objc func loginTextFieldChanged() {
        loginTextField.toggleIcons()
        viewModel.updateUsername(loginTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    @objc func passwordTextFieldChanged() {
        passwordTextField.toggleIcons()
        viewModel.updatePassword(passwordTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    // MARK: - Bindings
    private func bindToViewModel() {
        viewModel.isSignInButtonActive = { [weak self] isActive in
            self?.signInButton.toggleStyle(isActive ? .filled : .inactive)
        }
    }
}

// MARK: - Constants
private extension SignInViewController {
    enum Constants {
        static let horizontalEdgesConstraintsValue: CGFloat = 24
        static let stackViewSpacing: CGFloat = 8
        static let stackViewCustomSpacing: CGFloat = 32
    }
}

