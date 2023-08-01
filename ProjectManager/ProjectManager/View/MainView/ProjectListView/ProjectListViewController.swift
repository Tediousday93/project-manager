//
//  ProjectListViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import UIKit

final class ProjectListViewController: UIViewController {
    private enum Section: Hashable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Project.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Project.ID>
    
    private let tableView: UITableView = UITableView()
    private var dataSource: DataSource?
    private let viewModel: ProjectListViewModel
    
    init(viewModel: ProjectListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        setupLayoutConstraints()
    }
    
    private func configureRootView() {
        self.view.addSubview(tableView)
        self.view.backgroundColor = .systemGray5
    }
    
    private func configureTableView() {
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension ProjectListViewController: UITableViewDelegate {
    
}
