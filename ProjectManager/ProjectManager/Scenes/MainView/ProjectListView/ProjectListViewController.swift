//
//  ProjectListViewController.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProjectListViewController: UIViewController {
    private typealias DataSource = RxTableViewSectionedReloadDataSource<SectionOfProject>
    
    private let tableView: UITableView = UITableView()
    private lazy var dataSource = DataSource(configureCell: { _, tableView, indexPath, project in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProjectTableViewCell.identifier,
            for: indexPath
        ) as? ProjectTableViewCell else {
            fatalError("Fail to dequeue reusable cell")
        }
        
        let cellViewModel = ProjectItemViewModel(dateFormatter: self.dateFormatter)
        
        cell.viewModel = cellViewModel
        cell.bind(project)
        
        return cell
    })
    
    private var disposeBag: DisposeBag = .init()
    
    private let viewModel: ProjectListViewModel
    private let dateFormatter: DateFormatter
    
    init(viewModel: ProjectListViewModel,
         dateFormatter: DateFormatter) {
        self.viewModel = viewModel
        self.dateFormatter = dateFormatter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        disposeBag = .init()
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
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.updateTrigger.accept(())
    }
    
    private func configureRootView() {
        self.view.addSubview(tableView)
        self.view.backgroundColor = .systemGray5
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.identifier)
        tableView.separatorInset = .zero
        tableView.backgroundColor = .systemGray6
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
    
    private func setupBindings() {
        let input = ProjectListViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input)
        
        output.projectListFetched
            .drive()
            .disposed(by: disposeBag)
        
        output.updateProjectViewPresented
            .drive()
            .disposed(by: disposeBag)
       
        
        let projectState = viewModel.projectState
        
        viewModel.projectList
            .withUnretained(self)
            .map { owner, projectList in
                [SectionOfProject(header: projectState.rawValue, items: projectList)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Section for DataSource
fileprivate struct SectionOfProject {
    var header: String
    var items: [Item]
}

extension SectionOfProject: SectionModelType {
    typealias Item = Project
    
    init(original: SectionOfProject, items: [Project]) {
        self = original
        self.items = items
    }
}

// MARK: - TableView Delegate

extension ProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        selectedCell.isSelected = false
    }
}
