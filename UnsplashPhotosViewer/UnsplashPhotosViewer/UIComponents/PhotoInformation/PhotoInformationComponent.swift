//
//  PhotoInformationComponent.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 22/10/24.
//

import UIKit

// MARK: - Photo information component

class PhotoInformation: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(stackView)
        setupConstraints()
    }
    
}

// MARK: - Configuration

extension PhotoInformation {
    
    func configure(with model: PhotoDetail, isLandscape: Bool) {
        // Update the title
        titleLabel.text = model.description
        
        // Clear any existing arranged views in the stack view
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.axis = isLandscape ? .vertical : .horizontal
        stackView.spacing = isLandscape ? 40 : 0
        stackView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: isLandscape ? -70 : -50
        ).isActive = true
        
        // Add new items to the stack view
        renderItem(
            labelText: "Likes",
            icon: "hand.thumbsup.fill",
            value: model.likes
        )
        renderItem(
            labelText: "Downloads",
            icon: "arrow.down.square.fill",
            value: model.downloads
        )
    }
    
}

// MARK: - Setup UI

private extension PhotoInformation {
    
    func renderItem(labelText: String, icon: String, value: Int) {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        iconImageView.image = UIImage(systemName: icon)
        
        let label = UILabel()
        label.text = labelText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        let valueLabel = UILabel()
        valueLabel.text = String(value)
        valueLabel.textAlignment = .left
        valueLabel.font = UIFont.systemFont(ofSize: 32)
        
        let metadataStackView = UIStackView(arrangedSubviews: [iconImageView, label])
        metadataStackView.axis = .vertical
        metadataStackView.alignment = .center
        metadataStackView.spacing = 5
        metadataStackView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let photoItemStackView = UIStackView(arrangedSubviews: [metadataStackView, valueLabel])
        photoItemStackView.axis = .horizontal
        photoItemStackView.alignment = .center
        photoItemStackView.distribution = .fillProportionally
        photoItemStackView.spacing = 5
        
        stackView.addArrangedSubview(photoItemStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
