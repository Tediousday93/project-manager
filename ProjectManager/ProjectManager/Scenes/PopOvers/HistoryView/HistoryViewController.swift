//
//  HistoryViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HistoryViewController: UIViewController {
    private typealias DataSource = RxTableViewSectionedReloadDataSource<SectionOfProjectHistory>
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        formatter.locale = Locale(identifier: "en")
        
        return formatter
    }()
    
    private let tableView: UITableView = .init()
    
    private lazy var dataSource = DataSource(configureCell: { [weak self] _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.identifier,
            for: indexPath
        )
        as? HistoryTableViewCell else {
            fatalError("Fail to dequeue reusable cell")
        }
        
        cell.dateFormatter = self?.dateFormatter
        
        return cell
    })
    
    private let viewModel: HistoryViewModel
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureTableView()
        setupLayoutConstraints()
        setupBindings()
    }
    
    private func configureRootView() {
        view.addSubview(tableView)
        view.backgroundColor = .systemGray5
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.separatorStyle = .singleLine
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupBindings() {
        let input = HistoryViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.map { _ in }
        )
        let output = viewModel.transform(input)
    }
}

// MARK: - Section for DataSource
fileprivate struct SectionOfProjectHistory {
    var header: String?
    var items: [Item]
}

extension SectionOfProjectHistory: SectionModelType {
    typealias Item = (String, Date)
    
    init(original: SectionOfProjectHistory, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - TableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    
}
