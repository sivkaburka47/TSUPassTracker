//
//  UITextField+Extensions.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import UIKit

// MARK: - Date Picker
extension UITextField {
    
    func configureDatePicker(target: Any, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ru_RU")

        self.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: target, action: selector)
        let clearButton = UIBarButtonItem(title: "Очистить", style: .plain, target: target, action: #selector(clearDate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([flexibleSpace, clearButton, doneButton], animated: true)
        
        self.inputAccessoryView = toolbar
    }

    @objc func clearDate() {
        self.text = nil
        sendActions(for: .editingChanged)
        resignFirstResponder()
    }
    
    func setDate(from datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        
        if preferredLanguage.starts(with: "ru") {
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM yyyy"
        } else {
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "MMMM d, yyyy"
        }
        
        let date = datePicker.date
        let formattedDate = formatter.string(from: date)
        self.text = formattedDate
    }
}

