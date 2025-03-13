//
//  AddRequestScreen.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 11.03.2025.
//

import UIKit
import MobileCoreServices

final class AddRequestViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: AddRequestViewModel
    var onDismiss: (() -> Void)?
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let sizeButton = SplitButton(style: .sizePicker)
    private let dateFromTextField = CustomTextField(style: .date(.dateFrom))
    private let dateToTextField = CustomTextField(style: .date(.dateToOptional))
    private let addFileButton = SplitCustomButton(style: .gray)
    private let filesStackView = UIStackView()
    private let addButton = CustomButton(style: .inactive)
    
    // MARK: - Lifecycle
    init(viewModel: AddRequestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupScrollView()
        setupUIComponents()
        bindViewModel()
        setupKeyboardHandling()
        configureAddButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupUIComponents() {
        configureMainStackView()
        configureRequestTypeButton()
        configureDateFields()
        configureFileSection()
    }
    
    // MARK: - UI Configuration
    private func configureMainStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 24
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().priority(.high)
        }
    }
    
    private func configureRequestTypeButton() {
        stackView.addArrangedSubview(sizeButton)
        sizeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    private func configureDateFields() {
        dateFromTextField.delegate = self
        dateFromTextField.addTarget(self, action: #selector(dateFromChanged), for: .editingDidEnd)
        stackView.addArrangedSubview(dateFromTextField)
        
        dateToTextField.delegate = self
        dateToTextField.addTarget(self, action: #selector(dateToChanged), for: .editingDidEnd)
        stackView.addArrangedSubview(dateToTextField)
    }
    
    private func configureFileSection() {
        filesStackView.axis = .vertical
        filesStackView.spacing = 8
        stackView.addArrangedSubview(filesStackView)
        
        configureAddFileButton()
    }
    
    private func configureAddFileButton() {
        addFileButton.setTitle("Добавить файлы", for: .normal)
        addFileButton.showsMenuAsPrimaryAction = true
        addFileButton.menu = createFileMenu()
        stackView.addArrangedSubview(addFileButton)
    }
    
    private func configureAddButton() {
        addButton.setTitle("Создать заявку", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
    // MARK: - File Handling
    private func createFileMenu() -> UIMenu {
        let photoAction = UIAction(
            title: "Сделать фото",
            image: UIImage(systemName: "camera"),
            handler: { [weak self] _ in self?.handleCamera() }
        )
        
        let galleryAction = UIAction(
            title: "Выбрать из галереи",
            image: UIImage(systemName: "photo"),
            handler: { [weak self] _ in self?.handlePhotoLibrary() }
        )
        
        let documentAction = UIAction(
            title: "Выбрать файл",
            image: UIImage(systemName: "folder"),
            handler: { [weak self] _ in self?.handleDocumentPicker() }
        )
        
        return UIMenu(title: "Добавить вложение", children: [photoAction, galleryAction, documentAction])
    }
    
    private func updateFileDisplay() {
        filesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel.request.files.forEach { file in
            let fileView = FileItemView(
                fileData: file,
                onDelete: { [weak self] in
                    self?.viewModel.removeFile(file)
                    self?.updateFileDisplay()
                },
                onDownload: { [weak self] url in
                    self?.handleFileDownload(url: url)
                }
            )
            filesStackView.addArrangedSubview(fileView)
        }
    }
    
    private func handleFileDownload(url: URL) {
        let controller = UIDocumentInteractionController(url: url)
        controller.delegate = self
        controller.presentPreview(animated: true)
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        sizeButton.onSizeSelected = { [weak self] type in
            guard let confirmationType = ConfirmationTypeEntity(rawValue: type) else { return }
            self?.viewModel.updateConfirmationType(confirmationType)
            self?.updateDateToFieldStyle()
        }
        
        viewModel.isAddButtonActive = { [weak self] isActive in
            self?.addButton.toggleStyle(isActive ? .filled : .inactive)
        }
        
        viewModel.onError = { [weak self] error in
            self?.handleError(error)
        }
        
        viewModel.onSuccess = {
            self.closeButtonTapped()
        }
    }
    
    private func updateDateToFieldStyle() {
        let isMedical = viewModel.request.confirmationType == .medical
        let newStyle: CustomTextField.TextFieldStyle = isMedical ? .date(.dateToOptional) : .date(.dateTo)
        
        if dateToTextField.textFieldStyle != newStyle {
            dateToTextField.updateStyle(newStyle)
            dateToTextField.text = nil
            viewModel.updateDateTo(nil)
        }
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
    
    // MARK: - Actions
    @objc private func dateFromChanged() {
        guard let datePicker = dateFromTextField.inputView as? UIDatePicker else { return }
        viewModel.updateDateFrom(datePicker.date)
    }
    
    @objc private func dateToChanged() {
        guard let datePicker = dateToTextField.inputView as? UIDatePicker else { return }
        viewModel.updateDateTo(datePicker.date)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
        onDismiss?()
    }
    
    @objc private func addButtonTapped() {
        viewModel.createRequest()
    }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension AddRequestViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController ?? self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        cleanupTempFile(at: controller.url!)
    }
    
    private func cleanupTempFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting temp file: \(error.localizedDescription)")
        }
    }
}

// MARK: - Document Picker Delegate
extension AddRequestViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            do {
                let data = try Data(contentsOf: url)
                viewModel.addFile(data, fileName: url.lastPathComponent)
                
                updateFileDisplay()
            } catch {
                handleError("Не получилось загрузить файл.")
            }
        }
    }
}

// MARK: - Image Picker Delegate
extension AddRequestViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 0.7) else {
            picker.dismiss(animated: true)
            return
        }
        
        let fileName = "photo_\(Int(Date().timeIntervalSince1970)).jpg"
        viewModel.addFile(data, fileName: fileName)
        updateFileDisplay()
        picker.dismiss(animated: true)
    }
}

// MARK: - File Handling Methods
extension AddRequestViewController {
    private func handleCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func handlePhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func handleDocumentPicker() {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = true
        present(picker, animated: true)
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

// MARK: - Navigation Setup
extension AddRequestViewController {
    private func setupNavigationBar() {
        title = "Новая заявка"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
}

// MARK: - UITextFieldDelegate
extension AddRequestViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

