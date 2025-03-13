//
//  MainViewController.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit
import SnapKit

final class MainScreenViewController: UIViewController {
    private let viewModel: MainScreenViewModel
    
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let addButton = CustomButton(style: .filled)
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.onDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .requestAdded, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupTitleLabel()
        
        stackView.axis = .vertical
        stackView.spacing = -24
        stackView.clipsToBounds = false
        stackView.distribution = .fill
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view).inset(12)
            make.bottom.equalToSuperview().offset(-96)
        }
        
        configureAddButton()
    }

    private func setupTitleLabel() {
        titleLabel.text = "Мои заявки"
        titleLabel.font = .systemFont(ofSize: 36, weight: .regular)
        titleLabel.textColor = .black
        
        scrollView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(24)
        }
    }
    
    private func setupBindings() {
        viewModel.onDidLoadUserRequests = { [weak self] userRequests in
            self?.updateUI(with: userRequests)
        }
    }

    
    private func updateUI(with userRequests: ListLightRequests) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            if userRequests.listLightRequests.isEmpty {
                let emptyLabel = UILabel()
                emptyLabel.text = "Пока здесь пусто 🧐\nСоздайте свою первую заявку!"
                emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
                emptyLabel.textColor = .systemGray
                emptyLabel.numberOfLines = 0
                emptyLabel.textAlignment = .center
                
                let emptyView = UIView()
                emptyView.addSubview(emptyLabel)
                emptyLabel.snp.makeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
                
            } else {
                for request in userRequests.listLightRequests {
                    let cardView = RequestCardView(request: request)
                    
                    cardView.onEdit = { [weak self] id in
                        self?.viewModel.editRequest(id: id)
                    }
                    
                    cardView.onDownload = { [weak self] id in
                        self?.viewModel.saveFiles(id: id)
                    }
                    
                    self.stackView.addArrangedSubview(cardView)
                    cardView.snp.makeConstraints { make in
                        make.height.equalTo(180)
                    }
                }
            }
        }
    }
    
    private func configureAddButton() {
        addButton.setTitle("Добавить заявку", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
    @objc private func addButtonTapped() {
        viewModel.addNote()
    }
    
    @objc private func refreshData() {
        viewModel.onDidLoad()
    }
}
