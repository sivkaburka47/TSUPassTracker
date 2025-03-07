//
//  SignUpViewController.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {

    private var viewModel: SignUpViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private var titleLabel = UILabel()
    private let nameTextField = CustomTextField(style: .information(.name))
    private let surnameTextField = CustomTextField(style: .information(.surname))
    private let middlenameTextField = CustomTextField(style: .information(.middleName))
    private let groupTextField = CustomTextField(style: .information(.group))
    private let loginTextField = CustomTextField(style: .information(.username))
    private let passwordTextField = CustomTextField(style: .password(.password))
    private let repeatPasswordTextField = CustomTextField(style: .password(.repeatedPassword))
    
    private let signUpButton = CustomButton(style: .inactive)
    
    
    init(viewModel: SignUpViewModel) {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup
private extension SignUpViewController {
    func setup() {
        setupScrollView()
        setupContentView()
        configureStackView()
        setupView()
        addTapGestureToDismissKeyboard()
        setupKeyboardObservers()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.horizontalEdgesConstraintsValue)
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
        titleLabel.text = "Регистрация"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(20, after: titleLabel)
        
    }
    
    func configureTextFields() {
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        nameTextField.delegate = self
        stackView.addArrangedSubview(nameTextField)
        
        surnameTextField.addTarget(self, action: #selector(surnameTextFieldChanged), for: .editingChanged)
        surnameTextField.delegate = self
        stackView.addArrangedSubview(surnameTextField)
        
        middlenameTextField.addTarget(self, action: #selector(middlenameTextFieldChanged), for: .editingChanged)
        middlenameTextField.delegate = self
        stackView.addArrangedSubview(middlenameTextField)
        
        groupTextField.addTarget(self, action: #selector(groupTextFieldChanged), for: .editingChanged)
        groupTextField.delegate = self
        stackView.addArrangedSubview(groupTextField)
        
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        loginTextField.delegate = self
        stackView.addArrangedSubview(loginTextField)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        passwordTextField.delegate = self
        stackView.addArrangedSubview(passwordTextField)
        
        repeatPasswordTextField.addTarget(self, action: #selector(repeatPasswordTextFieldChanged), for: .editingChanged)
        repeatPasswordTextField.delegate = self
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: repeatPasswordTextField)
    }
    
    func configureButton() {
        signUpButton.setTitle("Зарегистрироваться", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(signUpButton)
    }
    
    
    
    func configureStackView() {
        configureTitleLabel()
        configureTextFields()
        configureButton()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.bottom.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
        }
    }
    
    
    func updateTextFieldValidation() {
        nameTextField.layer.borderColor = viewModel.isNameValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        nameTextField.layer.borderWidth = viewModel.isNameValid ? 0 : 1
        
        surnameTextField.layer.borderColor = viewModel.isSurnameValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        surnameTextField.layer.borderWidth = viewModel.isSurnameValid ? 0 : 1
        
        middlenameTextField.layer.borderColor = viewModel.isMiddlenameValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        middlenameTextField.layer.borderWidth = viewModel.isMiddlenameValid ? 0 : 1
        
        groupTextField.layer.borderColor = viewModel.isGroupValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        groupTextField.layer.borderWidth = viewModel.isGroupValid ? 0 : 1
        
        loginTextField.layer.borderColor = viewModel.isUsernameValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        loginTextField.layer.borderWidth = viewModel.isUsernameValid ? 0 : 1
        
        passwordTextField.layer.borderColor = viewModel.isPasswordValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        passwordTextField.layer.borderWidth = viewModel.isPasswordValid ? 0 : 1
        
        repeatPasswordTextField.layer.borderColor = viewModel.isRepeatedPasswordValid ? UIColor.clear.cgColor : UIColor.red.cgColor
        repeatPasswordTextField.layer.borderWidth = viewModel.isRepeatedPasswordValid ? 0 : 1
    }
    
    // MARK: - Actions
    @objc func signUpButtonTapped() {
        viewModel.signUpButtonTapped()
    }
    
    @objc func nameTextFieldChanged() {
        nameTextField.toggleIcons()
        viewModel.updateName(nameTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    @objc func surnameTextFieldChanged() {
        surnameTextField.toggleIcons()
        viewModel.updateSurname(surnameTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    @objc func middlenameTextFieldChanged() {
        middlenameTextField.toggleIcons()
        viewModel.updateMiddlename(middlenameTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    @objc func groupTextFieldChanged() {
        groupTextField.toggleIcons()
        viewModel.updateGroup(groupTextField.text ?? "")
        updateTextFieldValidation()
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
    
    @objc func repeatPasswordTextFieldChanged() {
        repeatPasswordTextField.toggleIcons()
        viewModel.updateRepeatedPassword(repeatPasswordTextField.text ?? "")
        updateTextFieldValidation()
    }
    
    
    
    // MARK: - Bindings
    private func bindToViewModel() {
        viewModel.isSignUpButtonActive = { [weak self] isActive in
            self?.signUpButton.toggleStyle(isActive ? .filled : .inactive)
        }
        
        viewModel.onError = { [weak self] error in
            self?.handleError(error)
        }
    }
    
    private func handleError(_ error: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeField = view.findFirstResponder() as? UITextField else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        let textFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        let bottomOfTextField = textFieldFrame.maxY
        
        let visibleHeight = scrollView.frame.height - keyboardHeight
        
        if bottomOfTextField > visibleHeight {
            let scrollPoint = CGPoint(x: 0, y: bottomOfTextField - visibleHeight + Constants.stackViewSpacing)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: - Constants
private extension SignUpViewController {
    enum Constants {
        static let horizontalEdgesConstraintsValue: CGFloat = 24
        static let stackViewSpacing: CGFloat = 8
        static let stackViewCustomSpacing: CGFloat = 32
    }
}
