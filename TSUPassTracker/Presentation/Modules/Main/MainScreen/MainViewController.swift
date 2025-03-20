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
    
    private let confirmationTypeSegmentedControl = UISegmentedControl(items: ["Все", "Медицинская", "Семейная", "Учебная"])
    private let statusSegmentedControl = UISegmentedControl(items: ["Все", "В ожидании", "Принята", "Отклонена"])
    private let sortSegmentedControl = UISegmentedControl(items: ["Новые", "Старые"])
    
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
        setupFilterActions()
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
        setupFilters()
        
        stackView.axis = .vertical
        stackView.spacing = -24
        stackView.clipsToBounds = false
        stackView.distribution = .fill
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(sortSegmentedControl.snp.bottom).offset(24)
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
    
    private func setupFilters() {
        let filterStackView = UIStackView()
        filterStackView.axis = .vertical
        filterStackView.spacing = 12

        let confirmationLabel = UILabel()
        confirmationLabel.text = "Тип подтверждения"
        confirmationLabel.font = .systemFont(ofSize: 16, weight: .medium)
        filterStackView.addArrangedSubview(confirmationLabel)
        confirmationTypeSegmentedControl.selectedSegmentIndex = 0
        filterStackView.addArrangedSubview(confirmationTypeSegmentedControl)
        
        let statusLabel = UILabel()
        statusLabel.text = "Статус"
        statusLabel.font = .systemFont(ofSize: 16, weight: .medium)
        filterStackView.addArrangedSubview(statusLabel)
        statusSegmentedControl.selectedSegmentIndex = 0
        filterStackView.addArrangedSubview(statusSegmentedControl)
        
        let sortLabel = UILabel()
        sortLabel.text = "Сортировка"
        sortLabel.font = .systemFont(ofSize: 16, weight: .medium)
        filterStackView.addArrangedSubview(sortLabel)
        sortSegmentedControl.selectedSegmentIndex = 0
        filterStackView.addArrangedSubview(sortSegmentedControl)
        
        scrollView.addSubview(filterStackView)
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view).inset(24)
        }
    }
    
    private func setupBindings() {
        viewModel.onDidLoadUserRequests = { [weak self] userRequests in
            self?.updateUI(with: userRequests)
        }
    }
    
    private func setupFilterActions() {
        confirmationTypeSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        statusSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        sortSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }
    
    @objc private func filterChanged() {
        let confirmationType: ConfirmationType?
        switch confirmationTypeSegmentedControl.selectedSegmentIndex {
        case 0: confirmationType = nil
        case 1: confirmationType = .medical
        case 2: confirmationType = .family
        case 3: confirmationType = .educational
        default: confirmationType = nil
        }
        
        let status: RequestStatus?
        switch statusSegmentedControl.selectedSegmentIndex {
        case 0: status = nil
        case 1: status = .pending
        case 2: status = .approved
        case 3: status = .rejected
        default: status = nil
        }
        
        let sort: SortEnum?
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: sort = .createdDesc
        case 1: sort = .createdAsc
        default: sort = nil
        }
        
        viewModel.updateFilters(confirmationType: confirmationType, status: status, sort: sort)
    }
    
    private func updateUI(with userRequests: ListLightRequests) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            if userRequests.listLightRequests.isEmpty {
                let emptyLabel = UILabel()
                emptyLabel.text = "Пока здесь пусто 🧐"
                emptyLabel.font = .systemFont(ofSize: 18, weight: .medium)
                emptyLabel.textColor = .systemGray
                emptyLabel.numberOfLines = 0
                emptyLabel.textAlignment = .center
                
                let emptyView = UIView()
                emptyView.addSubview(emptyLabel)
                
                emptyView.snp.makeConstraints {
                    $0.height.equalTo(200)
                }
                
                stackView.addArrangedSubview(emptyView)
                
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
