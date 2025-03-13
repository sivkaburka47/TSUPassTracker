//
//  SplitCustomButton.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation

import UIKit

final class SplitCustomButton: UIButton {
    
    enum ButtonStyle {
        case white
        case gray
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
        self.buttonStyle = .gray
        super.init(coder: coder)
        setupButton()
        configureStyle()
    }
    
    private func setupButton() {
        layer.cornerRadius = 14
        clipsToBounds = true
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    private func configureStyle() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        switch buttonStyle {
        case .white:
            backgroundColor = UIColor.white
            setTitleColor(.black, for: .normal)
            isUserInteractionEnabled = true
        case .gray:
            backgroundColor = UIColor.systemGray6
            setTitleColor(.black, for: .normal)
            isUserInteractionEnabled = true
        case .inactive:
            backgroundColor = .darkGray
            setTitleColor(.black, for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
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

