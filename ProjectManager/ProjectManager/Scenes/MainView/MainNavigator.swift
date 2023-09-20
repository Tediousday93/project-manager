//
//  MainNavigator.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import UIKit

protocol MainNavigator {
    func toMain()
    func toCreateProject()
    func toUpdateProject(_ project: Project)
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
    
    func toCreateProject() {
        let createProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let createProjectViewModel = CreateProjectViewModel(
            navigator: createProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Cancel"
        )
        let createProjectViewController = EditProjectViewController(
            viewModel: createProjectViewModel
        )
        let createProjectNavigationController = UINavigationController(
            rootViewController: createProjectViewController
        )
        
        self.navigationController.modalPresentationStyle = .formSheet
        self.navigationController.present(createProjectNavigationController, animated: true)
    }
    
    func toUpdateProject(_ project: Project) {
        let updateProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let updateProjectViewModel = UpdateProjectViewModel(
            navigator: updateProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Edit"
        )
        let updateProjectViewController = EditProjectViewController(
            viewModel: updateProjectViewModel
        )
        let updateProjectNavigationController = UINavigationController(
            rootViewController: updateProjectViewController
        )
        
        self.navigationController.modalPresentationStyle = .formSheet
        self.navigationController.present(updateProjectNavigationController, animated: true)
    }
}
