//
//  MainNavigator.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import UIKit

protocol MainNavigator {
    func toMain()
    func toCreateProject(delegate: EditViewModelDelegate?)
    func toUpdate(_ project: Project, delegate: EditViewModelDelegate?)
    func toChangeState()
}

final class DefaultMainNavigator: MainNavigator {
    private let coreDataService: UseCaseProvider
    private let navigationController: UINavigationController
    
    init(coreDataService: UseCaseProvider,
         navigationController: UINavigationController) {
        self.coreDataService = coreDataService
        self.navigationController = navigationController
    }
    
    func toMain() {
        let mainViewModel = MainViewModel(
            navigator: self,
            coreDataUseCase: coreDataService.makeProjectListUseCase()
        )
        let mainViewController = MainViewController(viewModel: mainViewModel)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func toCreateProject(delegate: EditViewModelDelegate?) {
        let createProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let createProjectViewModel = CreateProjectViewModel(
            navigator: createProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Cancel",
            sourceProject: nil
        )
        let createProjectViewController = EditProjectViewController(
            viewModel: createProjectViewModel
        )
        let createProjectNavigationController = UINavigationController(
            rootViewController: createProjectViewController
        )
        
        createProjectViewModel.delegate = delegate
        createProjectNavigationController.modalPresentationStyle = .formSheet
        
        self.navigationController.present(createProjectNavigationController, animated: true)
    }
    
    func toUpdate(_ project: Project, delegate: EditViewModelDelegate?) {
        let updateProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let updateProjectViewModel = UpdateProjectViewModel(
            navigator: updateProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Edit",
            sourceProject: project
        )
        let updateProjectViewController = EditProjectViewController(
            viewModel: updateProjectViewModel
        )
        let updateProjectNavigationController = UINavigationController(
            rootViewController: updateProjectViewController
        )
        updateProjectViewModel.delegate = delegate
        updateProjectNavigationController.modalPresentationStyle = .formSheet
        
        self.navigationController.present(updateProjectNavigationController, animated: true)
    }
    
    func toChangeState() {
        
    }
}
