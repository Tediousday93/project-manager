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
        
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray2
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
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    weak var dateFormatter: DateFormatter?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViewHierarchy()
        setupLayoutConstraints()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        bodyLabel.text = nil
        dateLabel.text = nil
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        )
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
    
    func configureContents(with source: Project) {
        titleLabel.text = source.title
        dateLabel.text = dateFormatter?.string(from: source.date)
        bodyLabel.text = source.body
        
        if source.date.compare(Date()) == .orderedAscending {
            dateLabel.textColor = .systemRed
        } else {
            dateLabel.textColor = .black
        }

//        let input = ProjectTableViewCellViewModel.Input(
//            contentsUpdateTrigger: contentsUpdateTrigger
//        )
//        let output = viewModel.transform(input)
//
//        [output.title.bind(to: titleLabel.rx.text),
//         output.body.bind(to: bodyLabel.rx.text),
//         output.dateString.bind(to: dateLabel.rx.text)]
//            .forEach { $0.disposed(by: disposeBag) }
//
//        output.isDateExpired
//            .drive(with: self, onNext: { owner, isDateExpired in
//                if isDateExpired {
//                    owner.dateLabel.textColor = .systemRed
//                } else {
//                    owner.dateLabel.textColor = .black
//                }
//            })
//            .disposed(by: disposeBag)
    }
}

extension ProjectTableViewCell: IdentifierProtocol { }
