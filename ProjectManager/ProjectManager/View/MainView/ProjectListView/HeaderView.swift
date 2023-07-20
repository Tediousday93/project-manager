//
//  HeaderView.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit

final class HeaderView: UIView {
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .black
        
        return label
    }()
    
    let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewHierarchy() {
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(badgeLabel)
        
        self.addSubview(stackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
