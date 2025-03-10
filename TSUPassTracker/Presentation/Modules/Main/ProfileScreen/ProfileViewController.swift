//
//  ProfileViewController.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 06.03.2025.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let infoStackView = UIStackView()
    private let rolesStackView = UIStackView()
    private let userGroupLabel = PaddedLabel()
    private let userIsConfirmedLabel = PaddedLabel()
    private let logoutButton = CustomButton(style: .filled)
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.onDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupTitleLabel()
        setupProfileImage()
        setupUserNameLabel()
        setupInfoStackView()
        setupLogoutButton()
    }
    
    private func setupBindings() {
        viewModel.onDidLoadUserData = { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    // MARK: - UI Update
    private func updateUI() {
        userNameLabel.text = viewModel.userData.name
        clearExistingViews()
        configureInfoStackView()
    }
    
    private func clearExistingViews() {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rolesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UI Configuration
extension ProfileViewController {
    private func setupTitleLabel() {
        titleLabel.text = "Профиль"
        titleLabel.font = .systemFont(ofSize: 36, weight: .regular)
        titleLabel.textColor = .black
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    private func setupProfileImage() {
        profileImageView.image = UIImage(named: "avatarIcon")
        profileImageView.layer.cornerRadius = 48
        profileImageView.clipsToBounds = true
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(96)
        }
    }
    
    private func setupUserNameLabel() {
        userNameLabel.numberOfLines = 0
        userNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .black
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 16
        infoStackView.alignment = .fill
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func configureInfoStackView() {
        setupRolesStackView()
        infoStackView.addArrangedSubview(rolesStackView)
        addGroupInfo()
        addConfirmationStatus()
    }
    
    private func setupRolesStackView() {
        rolesStackView.axis = .vertical
        rolesStackView.spacing = 8
        rolesStackView.distribution = .fillEqually
        
        var currentRow: UIStackView?
        var currentRowWidth: CGFloat = 0
        let maxWidth = view.bounds.width - 48
        
        for role in viewModel.userData.roles {
            let label = createRoleLabel(text: role.rawValue)
            let labelWidth = label.intrinsicContentSize.width + 32
            
            if let row = currentRow, (currentRowWidth + labelWidth + 8) <= maxWidth {
                row.addArrangedSubview(label)
                currentRowWidth += labelWidth + 8
            } else {
                let newRow = createNewRow()
                newRow.addArrangedSubview(label)
                rolesStackView.addArrangedSubview(newRow)
                currentRow = newRow
                currentRowWidth = labelWidth
            }
        }
    }
    
    private func createRoleLabel(text: String) -> PaddedLabel {
        let label = PaddedLabel()
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }
    
    private func createNewRow() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }
    
    private func addGroupInfo() {
        guard let group = viewModel.userData.group else { return }
        
        userGroupLabel.text = "Группа: \(group)"
        userGroupLabel.textAlignment = .center
        userGroupLabel.backgroundColor = .systemGray4
        userGroupLabel.textColor = .black
        userGroupLabel.font = .systemFont(ofSize: 16, weight: .medium)
        userGroupLabel.layer.cornerRadius = 8
        userGroupLabel.clipsToBounds = true
        
        infoStackView.addArrangedSubview(userGroupLabel)
    }
    
    private func addConfirmationStatus() {
        let text = viewModel.userData.isConfirmed ? "Подтверждён" : "Не подтверждён"
        let color = viewModel.userData.isConfirmed ? UIColor.systemGreen : .systemRed
        
        userIsConfirmedLabel.text = text
        userIsConfirmedLabel.textAlignment = .center
        userIsConfirmedLabel.backgroundColor = color.withAlphaComponent(0.2)
        userIsConfirmedLabel.textColor = color
        userIsConfirmedLabel.font = .systemFont(ofSize: 16, weight: .medium)
        userIsConfirmedLabel.layer.cornerRadius = 8
        userIsConfirmedLabel.clipsToBounds = true
        
        infoStackView.addArrangedSubview(userIsConfirmedLabel)
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle("Выйти из аккаунта", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(infoStackView.snp.bottom).offset(32)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
    }
}

