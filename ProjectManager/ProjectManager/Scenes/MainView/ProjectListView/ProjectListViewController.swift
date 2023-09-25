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
        tableView.register(ProjectTableViewCell.self,
                           forCellReuseIdentifier: ProjectTableViewCell.identifier)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
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
        let projectState = viewModel.projectState
        
        let sections = viewModel.projectList
            .withUnretained(self)
            .map { owner, projectList in
                [SectionOfProject(header: projectState.rawValue, items: projectList)]
            }
            .share()
        
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        sections
            .compactMap { sections in
                guard let section = sections.first else { return nil }
                
                let headerView = HeaderView(frame: .init(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
                headerView.bind(header: section.header,
                                badge: section.items.count)
                
                return headerView
            }
            .bind(to: tableView.rx.tableHeaderView)
            .disposed(by: disposeBag)
        
        let input = ProjectListViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asDriver(),
            itemDeleted: tableView.rx.itemDeleted.asDriver()
        )
        let output = viewModel.transform(input)
        
        output.projectListFetched
            .drive()
            .disposed(by: disposeBag)
        
        output.updateProjectViewPresented
            .drive()
            .disposed(by: disposeBag)
        
        output.deleteProject
            .observe(on: MainScheduler.instance)
            .catch({ error in
                print(error)
                // Alert 띄우기
                return Observable.just(nil)
            })
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.removeDataSourceItem(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func removeDataSourceItem(at indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        var items = viewModel.projectList.value
        items.remove(at: indexPath.row)
        
        viewModel.projectList.accept(items)
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
