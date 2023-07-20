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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        setupLayoutConstraints()
    }
    
    private func configureRootView() {
        view.addSubview(tableView)
    }
    
    private func configureTableView() {
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ProjectListViewController: UITableViewDelegate {
    
}
