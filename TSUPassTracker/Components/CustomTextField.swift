//
//  CustomTextField.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit
import SnapKit

final class CustomTextField: UITextField {
    
    enum PlaceholderText {
        enum Information {
            case username, email, name
        }
        
        enum Password {
            case password, repeatedPassword
        }
        
        enum Date {
            case dateOfBirth
        }
    }
    
    enum TextFieldStyle {
        case information(PlaceholderText.Information)
        case password(PlaceholderText.Password)
        case date(PlaceholderText.Date)
        case plain
    }
    
    private var placeholderText: String = ""
    var textFieldStyle: TextFieldStyle
    private let rightButton = UIButton(type: .custom)
    
    init(style: TextFieldStyle) {
        self.textFieldStyle = style
        super.init(frame: .zero)
        configurePlaceholderText()
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 40, y: (bounds.height - 24) / 2, width: 24, height: 24)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 16, y: bounds.origin.y, width: bounds.width - 60, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

private extension CustomTextField {
    func configureTextField() {
        layer.cornerRadius = 8
        backgroundColor = UIColor.systemGray6
        
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        font = UIFont.preferredFont(forTextStyle: .body)
        textColor = .label
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        configureRightButton()
        
        switch textFieldStyle {
        case .password:
            isSecureTextEntry = true
        default:
            break
        }
    }
    
    func configureRightButton() {
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rightButton.contentMode = .scaleAspectFit
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        
        switch textFieldStyle {
        case .information:
            rightButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
            rightButton.isHidden = true
        case .password:
            rightButton.setImage(UIImage(systemName: "eye.slash", withConfiguration: config), for: .normal)
            rightButton.isHidden = true
        case .date:
            rightButton.setImage(UIImage(systemName: "calendar", withConfiguration: config), for: .normal)
            rightButton.tintColor = .systemGray
        case .plain:
            rightButton.isHidden = true
        }
        
        rightView = rightButton
        rightViewMode = .always
    }
    
    @objc func buttonTapped() {
        switch textFieldStyle {
        case .date:
            self.becomeFirstResponder()
        case .password:
            togglePasswordIcon()
        case .information:
            text = ""
            sendActions(for: .editingChanged)
        case .plain:
            break
        }
    }
    
    func togglePasswordIcon() {
        let isSecure = isSecureTextEntry
        isSecureTextEntry.toggle()
        
        let imageName = isSecure ? "eye.slash" : "eye"
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        rightButton.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }
    
    @objc func doneButtonPressed() {
        resignFirstResponder()
    }
    
    func configurePlaceholderText() {
        placeholderText = placeholderString(for: textFieldStyle)
    }
    
    func placeholderString(for style: TextFieldStyle) -> String {
        switch style {
        case .information(let info):
            return placeholderString(for: info)
        case .password(let password):
            return placeholderString(for: password)
        case .date(let date):
            return placeholderString(for: date)
        case .plain:
            return ""
        }
    }
    
    func placeholderString(for information: PlaceholderText.Information) -> String {
        switch information {
        case .username:
            return "Логин"
        case .email:
            return "Почта"
        case .name:
            return "ФИО"
        }
    }
    
    func placeholderString(for password: PlaceholderText.Password) -> String {
        switch password {
        case .password:
            return "Пароль"
        case .repeatedPassword:
            return "Повторите пароль"
        }
    }
    
    func placeholderString(for date: PlaceholderText.Date) -> String {
        switch date {
        case .dateOfBirth:
            return "Date of Birth"
        }
    }
}

extension CustomTextField {
    func toggleIcons() {
        let hasText = !(text?.isEmpty ?? true)
        
        switch textFieldStyle {
        case .information, .password:
            rightButton.isHidden = !hasText
            rightButton.tintColor = hasText ? .label : .systemGray
        case .date:
            rightButton.isHidden = false
            rightButton.tintColor = hasText ? .label : .systemGray
        case .plain:
            rightButton.isHidden = true
        }
        
        rightView = rightButton
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textFieldStyle {
        case .date:
            return false
        case .information, .password, .plain:
            return true
        }
    }
}
