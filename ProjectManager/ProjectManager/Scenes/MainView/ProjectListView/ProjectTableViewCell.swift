//
//  ProjectTableViewCell.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/17.
//

import UIKit
import RxSwift
import RxCocoa

final class ProjectTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        
        return label
    }()
    
    private let upperLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let disposeBag: DisposeBag = .init()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewHierarchy()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        bodyLabel.text = nil
        dateLabel.text = nil
    }
    
    private func configureViewHierarchy() {
        upperLabelStackView.addArrangedSubview(titleLabel)
        upperLabelStackView.addArrangedSubview(bodyLabel)
        
        contentsStackView.addArrangedSubview(upperLabelStackView)
        contentsStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(contentsStackView)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func bind(_ project: Project, dateFormatter) {
        Observable.just(project.title)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just(project.body)
            .bind(to: bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just(project.date)
            .map { date in
                
            }
            
    }
}

extension ProjectTableViewCell: IdentifierProtocol { }
