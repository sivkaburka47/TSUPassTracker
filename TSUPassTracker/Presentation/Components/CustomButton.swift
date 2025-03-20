//
//  CustomButton.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit

final class CustomButton: UIButton {
    
    enum ButtonStyle {
        case filled
        case plain
        case inactive
    }
    
    private var buttonStyle: ButtonStyle
    
    init(style: ButtonStyle) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setupButton()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        self.buttonStyle = .plain
        super.init(coder: coder)
        setupButton()
        configureStyle()
    }
    
    private func setupButton() {
        layer.cornerRadius = 8
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    private func configureStyle() {
        switch buttonStyle {
        case .filled:
            backgroundColor = UIColor.systemBlue
            setTitleColor(.white, for: .normal)
            isUserInteractionEnabled = true
        case .plain:
            backgroundColor = UIColor.systemGray5
            setTitleColor(.label, for: .normal)
            isUserInteractionEnabled = true
        case .inactive:
            backgroundColor = UIColor.systemGray4
            setTitleColor(.systemGray, for: .normal)
            isUserInteractionEnabled = false
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateButtonAppearance(for: isHighlighted)
        }
    }
    
    private func updateButtonAppearance(for highlighted: Bool) {
        let targetAlpha: CGFloat = highlighted ? 0.7 : 1.0
        UIView.animate(withDuration: 0.1) {
            self.alpha = targetAlpha
        }
    }
    
    func getCurrentStyle() -> ButtonStyle {
        return self.buttonStyle
    }
    
    func toggleStyle(_ style: ButtonStyle) {
        buttonStyle = style
        configureStyle()
    }
}
