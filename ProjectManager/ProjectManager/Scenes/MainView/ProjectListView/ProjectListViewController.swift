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
import RxGesture

final class ProjectListViewController: UIViewController {
    private typealias DataSource = RxTableViewSectionedReloadDataSource<SectionOfProject>
    
    private let tableView: UITableView = .init()
    private var longPressedCell: UITableViewCell?
    
    private lazy var dataSource = DataSource(configureCell: { [unowned self] _, tableView, indexPath, project in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProjectTableViewCell.identifier,
            for: indexPath
        ) as? ProjectTableViewCell else {
            fatalError("Fail to dequeue reusable cell")
        }
        
        cell.dateFormatter = self.dateFormatter
        cell.configureContents(with: project)
        
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
        configureDataSource()
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
        tableView.register(ProjectTableViewCell.self,
                           forCellReuseIdentifier: ProjectTableViewCell.identifier)
        tableView.register(HeaderView.self,
                           forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDataSource() {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
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
// MARK: - Bind UI
        // Controll Event 연관값 활용 Recognizer 학습 필요
        tableView.rx.longPressGesture()
            .when(.began)
            .asLocation()
            .subscribe(with: self) { owner, location in
                owner.saveLongPressedCell(at: location)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
            
        
        let longPressEnded = tableView.rx.longPressGesture()
            .when(.ended)
            .asLocation()
            .withUnretained(self)
            .map { owner, location in
                if owner.islongPressedCellChanged(location: location) == false {
                    return owner.tableView.indexPathForRow(at: location)
                } else {
                    return nil
                }
            }
            .asDriver(onErrorJustReturn: nil)
        
        let input = ProjectListViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asDriver(),
            itemDeleted: tableView.rx.itemDeleted.asDriver(),
            longPressEnded: longPressEnded
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
                    
        output.longPressedCellSource
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, changeStateViewModel in
                try? ChangeStatePopOverBuilder(presentingViewController: owner)
                    .withSourceView(owner.longPressedCell)
                    .arrowDirections(.up)
                    .preferredContentSize(CGSize(width: 300, height: 120))
                    .show(with: changeStateViewModel)
            })
            .disposed(by: disposeBag)
        
// MARK: - Bind State
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

// MARK: - LongPressGestureRecognizer
extension ProjectListViewController {
    private func saveLongPressedCell(at location: CGPoint) {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        self.longPressedCell = cell
    }
    
    private func islongPressedCellChanged(location: CGPoint) -> Bool {
        guard let indexPath = tableView.indexPathForRow(at: location),
              let previousCell = self.longPressedCell,
              let currentCell = tableView.cellForRow(at: indexPath) else {
            return true
        }
        
        return currentCell == previousCell ? false : true
    }
}
