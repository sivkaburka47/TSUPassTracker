//
//  SplitButton.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import UIKit



class SplitButton: UIView {
    
    enum ButtonStyle {
        case sizePicker
    }
    
    let smallButton: SplitCustomButton
    let mediumButton: SplitCustomButton
    let largeButton: SplitCustomButton
    
    private var style: ButtonStyle
    
    var onSizeSelected: ((String) -> Void)?
    
    init(style: ButtonStyle) {
        self.style = style
        self.smallButton = SplitCustomButton(style: .white)
        self.mediumButton = SplitCustomButton(style: .gray)
        self.largeButton = SplitCustomButton(style: .gray)
        
        super.init(frame: .zero)
        
        setupView()
        setupButtons()
        configureButtons()
        layoutButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor.systemGray6
    }
    
    private func setupButtons() {
        smallButton.layer.cornerRadius = 14
        mediumButton.layer.cornerRadius = 14
        largeButton.layer.cornerRadius = 14
        
        smallButton.addTarget(self, action: #selector(smallButtonTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(mediumButtonTapped), for: .touchUpInside)
        largeButton.addTarget(self, action: #selector(largeButtonTapped), for: .touchUpInside)
        
        addSubview(smallButton)
        addSubview(mediumButton)
        addSubview(largeButton)
    }
    
    private func configureButtons() {
        switch style {
        case .sizePicker:
            smallButton.setTitle("Медицинская", for: .normal)
            mediumButton.setTitle("Семейная", for: .normal)
            largeButton.setTitle("Учебная", for: .normal)
        }
        
        smallButton.toggleStyle(.white)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.gray)
    }
    
    private func layoutButtons() {
        smallButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(2)
            make.trailing.equalTo(mediumButton.snp.leading).offset(-2)
            make.width.equalTo(mediumButton)
        }
        
        mediumButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.equalTo(smallButton.snp.trailing).offset(2)
            make.trailing.equalTo(largeButton.snp.leading).offset(-2)
            make.width.equalTo(smallButton)
        }
        
        largeButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(2)
            make.width.equalTo(smallButton)
        }
    }
    
    @objc private func smallButtonTapped() {
        smallButton.toggleStyle(.white)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.gray)
        onSizeSelected?("Медицинская")
    }
    
    @objc private func mediumButtonTapped() {
        smallButton.toggleStyle(.gray)
        mediumButton.toggleStyle(.white)
        largeButton.toggleStyle(.gray)
        onSizeSelected?("Семейная")
    }
    
    @objc private func largeButtonTapped() {
        smallButton.toggleStyle(.gray)
        mediumButton.toggleStyle(.gray)
        largeButton.toggleStyle(.white)
        onSizeSelected?("Учебная")
    }
}

