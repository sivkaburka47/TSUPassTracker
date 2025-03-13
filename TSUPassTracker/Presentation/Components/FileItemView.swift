//
//  FileItemView.swift
//  TSUPassTracker
//
//  Created by Станислав Дейнекин on 12.03.2025.
//

import Foundation
import UIKit

final class FileItemView: UIView {
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let sizeLabel = UILabel()
    private let progressView = UIProgressView()
    private let deleteButton = UIButton()
    
    private var fileData: FileData?
    private var onDelete: (() -> Void)?
    private var onDownload: ((URL) -> Void)?
    
    init(fileData: FileData,
         isDeletable: Bool,
         onDelete: @escaping () -> Void,
         onDownload: @escaping (URL) -> Void) {
        self.fileData = fileData
        self.onDelete = onDelete
        self.onDownload = onDownload
        super.init(frame: .zero)
        setupView()
        configure(with: fileData)
        setupGestures()
        setupDeleteButton()
        deleteButton.isHidden = !isDeletable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        backgroundColor = .systemGray5
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.numberOfLines = 2
        
        sizeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        sizeLabel.textColor = .secondaryLabel
        
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemRed
        
        progressView.isHidden = true
        progressView.progressTintColor = .systemBlue
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, sizeLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [iconView, textStack, deleteButton])
        mainStack.spacing = 12
        mainStack.alignment = .center
        
        addSubview(mainStack)
        addSubview(progressView)
        
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        
        iconView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func configure(with file: FileData) {
        nameLabel.text = file.fileName
        iconView.image = UIImage(systemName: file.systemIconName)
        
        let size = Double(file.data.count) / 1024.0
        sizeLabel.text = String(format: "%.1f KB", size)
    }

    @objc private func handleTap() {
        guard let fileData = fileData else { return }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileData.fileName)
        
        do {
            showProgress()
            try fileData.data.write(to: fileURL)
            hideProgress()
            onDownload?(fileURL)
        } catch {
            print("File save error: \(error.localizedDescription)")
        }
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func showProgress() {
        progressView.isHidden = false
        progressView.setProgress(0, animated: false)
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.setProgress(1.0, animated: true)
        }
    }
    
    private func hideProgress() {
        progressView.isHidden = true
    }
    
    private func setupDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
