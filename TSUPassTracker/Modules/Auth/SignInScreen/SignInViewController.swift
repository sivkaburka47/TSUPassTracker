//
//  SignInViewController.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit
import SnapKit

final class SignInViewController: UIViewController, UITextFieldDelegate {

    private var viewModel: SignInViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private var titleLabel = UILabel()
    private let loginTextField = CustomTextField(style: .information(.username))
    private let passwordTextField = CustomTextField(style: .password(.password))
    
    private let signInButton = CustomButton(style: .inactive)
    private var signUpLabel = UILabel()
    
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
        setupScrollView()
        setupContentView()
        configureStackView()
        setupView()
        addTapGestureToDismissKeyboard()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-Constants.horizontalEdgesConstraintsValue)
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Авторизация"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(20, after: titleLabel)
        
    }
    
    func configureTextFields() {
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        loginTextField.delegate = self
        stackView.addArrangedSubview(loginTextField)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        passwordTextField.delegate = self
        stackView.addArrangedSubview(passwordTextField)
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: passwordTextField)
    }
    
    func configureButton() {
        signInButton.setTitle("Войти", for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(signInButton)
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: signInButton)
    }
    
    func configureSignUpLabel() {
        signUpLabel = UILabel()
        signUpLabel.text = "Регистрация"
        signUpLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        signUpLabel.textColor = .systemBlue
        signUpLabel.textAlignment = .center
        signUpLabel.isUserInteractionEnabled = true
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateSignUpLabelTapped))
        signUpLabel.addGestureRecognizer(tapGesture)
        
        stackView.addArrangedSubview(signUpLabel)
    }
    
    
    func configureStackView() {
        configureTitleLabel()
        configureTextFields()
        configureButton()
        configureSignUpLabel()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.bottom.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
        }
    }
    

    
    func updateTextFieldValidation() {
        loginTextField.layer.borderColor = viewModel.isUsernameValid ? UIColor.clear.cgColor : UIColor.white.cgColor
        loginTextField.layer.borderWidth = viewModel.isUsernameValid ? 0 : 1
        
        passwordTextField.layer.borderColor = viewModel.isPasswordValid ? UIColor.clear.cgColor : UIColor.white.cgColor
        passwordTextField.layer.borderWidth = viewModel.isPasswordValid ? 0 : 1
    }
    
    // MARK: - Actions
    @objc func signInButtonTapped() {
        viewModel.signInButtonTapped()
    }
    
    
    @objc private func navigateSignUpLabelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        
        let textSize = label.intrinsicContentSize
        let textRect = CGRect(
            x: (label.bounds.width - textSize.width) * 0.5,
            y: (label.bounds.height - textSize.height) * 0.5,
            width: textSize.width,
            height: textSize.height
        )
        
        let location = gesture.location(in: label)
        
        if textRect.contains(location) {
            viewModel.navigateSignUpButtonTapped()
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

