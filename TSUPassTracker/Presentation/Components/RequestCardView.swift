//
//  RequestCardView.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 10.03.2025.
//

import UIKit
import SnapKit

final class RequestCardView: UIView {
    weak var spacerView: UIView?
    
    private let request: LightRequest
    private let containerView = UIView()
    private let borderLayer = CAShapeLayer()
    
    private var isExpanded = false
    private var expandedHeight: CGFloat = 360
    private var collapsedHeight: CGFloat = 180
    private var bottomSpacing: CGFloat = 0

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var dateCreatedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    var onEdit: ((String) -> Void)?
    var onDownload: ((String) -> Void)?

    private lazy var editButton: CustomButton = {
        let button = CustomButton(style: .filled)
        button.setTitle("Посмотреть детали", for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alpha = 0
        return stack
    }()
    
    init(request: LightRequest) {
        self.request = request
        super.init(frame: .zero)
        setupUI()
        configureContent()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleExpand)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.addSublayer(borderLayer)
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, statusLabel, dateCreatedLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 4
        contentStack.alignment = .center
        
        containerView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        containerView.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(48)
        }
    }
    
    private func configureContent() {
        let titleDateFormatter = DateFormatter()
        titleDateFormatter.locale = Locale(identifier: "ru_RU")
        titleDateFormatter.dateStyle = .medium
        titleDateFormatter.timeStyle = .none

        let dateFrom = titleDateFormatter.string(from: request.dateFrom)
        
        let dateToString = request.dateTo.flatMap {
            titleDateFormatter.string(from: $0)
        }
        
        titleLabel.text = [dateFrom, dateToString]
            .compactMap { $0 }
            .joined(separator: " - ")
        
        dateLabel.text = request.confirmationType.rawValue
        statusLabel.text = "Статус: \(request.status.rawValue)"
        let createdDateFormatter = DateFormatter()
        createdDateFormatter.locale = Locale(identifier: "ru_RU")
        createdDateFormatter.dateStyle = .long
        createdDateFormatter.timeStyle = .short
        createdDateFormatter.doesRelativeDateFormatting = true
        
        let createdDate = createdDateFormatter.string(from: request.createdDate)
        dateCreatedLabel.text = "Создана: \(createdDate)"
        
        updateBackgroundColor(for: request.status)
    }

    
    private func updateBackgroundColor(for status: RequestStatusEntity) {
        switch status {
        case .pending:
            containerView.backgroundColor = UIColor(named: "tuftBush")
        case .approved:
            containerView.backgroundColor = UIColor(named: "swampGreen")
        case .rejected:
            containerView.backgroundColor = UIColor(named: "tango")
        }
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        
        self.buttonsStack.alpha = self.isExpanded ? 1 : 0
        
        let newHeight = isExpanded ? expandedHeight : collapsedHeight
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
            self.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            self.superview?.layoutIfNeeded()
        }
        
        animateShapeExpansion()
        
        guard let stackView = self.superview as? UIStackView else { return }
        let index = stackView.arrangedSubviews.firstIndex(of: self) ?? 0

        if isExpanded {
            if self.spacerView == nil {
                let spacer = UIView()
                spacer.snp.makeConstraints { make in
                    make.height.equalTo(16)
                }
                stackView.insertArrangedSubview(spacer, at: index + 1)
                self.spacerView = spacer
            }
        } else {
            if let spacer = self.spacerView {
                stackView.removeArrangedSubview(spacer)
                spacer.removeFromSuperview()
                self.spacerView = nil
            }
        }
    }

    private func animateShapeExpansion() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = borderLayer.path
        animation.toValue = createPath(for: isExpanded ? expandedHeight : collapsedHeight).cgPath
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        borderLayer.add(animation, forKey: "path")
        borderLayer.path = createPath(for: isExpanded ? expandedHeight : collapsedHeight).cgPath
        containerView.layer.mask?.add(animation, forKey: "path")
        containerView.layer.mask?.setValue(borderLayer.path, forKey: "path")
    }
    
    private func createPath(for height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let width = containerView.bounds.width
        let bottomInset: CGFloat = isExpanded ? 0 : 8
        let cornerRadius: CGFloat = 24
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), controlPoint: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width - bottomInset, y: height - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: width - bottomInset - cornerRadius, y: height), controlPoint: CGPoint(x: width - bottomInset, y: height))
        path.addLine(to: CGPoint(x: bottomInset + cornerRadius, y: height))
        path.addQuadCurve(to: CGPoint(x: bottomInset, y: height - cornerRadius), controlPoint: CGPoint(x: bottomInset, y: height))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }

    private func updateShape() {
        let path = createPath(for: isExpanded ? expandedHeight : collapsedHeight)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
        borderLayer.path = path.cgPath
    }
    
    @objc private func editButtonTapped() {
        onEdit?(request.id)
    }
    
    @objc private func downloadButtonTapped() {
        onDownload?(request.id)
    }
}
