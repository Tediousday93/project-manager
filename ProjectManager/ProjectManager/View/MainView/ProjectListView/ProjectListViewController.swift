//
//  ProjectListViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import UIKit
import RxSwift
import RxCocoa

final class ProjectListViewController: UIViewController {
    private enum Section: Hashable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Project.ID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Project.ID>
    
    private let tableView: UITableView = UITableView()
    private var dataSource: DataSource?
    private let disposeBag: DisposeBag = .init()
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
        configureTableView()
        setupLayoutConstraints()
        configureDataSource()
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
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
    }
    
    private func cellProvider(
        _ tableView: UITableView,
        _ indexPath: IndexPath,
        _ itemIdentifier: Project.ID
    ) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProjectCell.identifier,
            for: indexPath
        ) as? ProjectCell
        
        guard let project = viewModel.retriveProject(for: itemIdentifier) else {
            return cell
        }
        
        return cell
    }
    
    private func bindState() {
        viewModel.projectCreated
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.applyLatestSnapshot()
            }
            .disposed(by: disposeBag)
        
        viewModel.projectUpdated
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, itemID in
                owner.reloadSnapshotItem(id: itemID)
            }
            .disposed(by: disposeBag)
        
        viewModel.projectDeleted
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, itemID in
                owner.deleteSnapshotItem(id: itemID)
            }
            .disposed(by: disposeBag)
            
    }
    
    private func applyLatestSnapshot() {
        let idList = viewModel.projectIDList
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(idList)
        dataSource?.apply(snapshot)
    }
    
    private func reloadSnapshotItem(id: UUID) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        snapshot.reloadItems([id])
        dataSource?.apply(snapshot)
    }
    
    private func deleteSnapshotItem(id: UUID) {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        snapshot.deleteItems([id])
        dataSource?.apply(snapshot)
    }
}

extension ProjectListViewController: UITableViewDelegate {
    
}
