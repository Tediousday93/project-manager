//
//  MainNavigator.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import UIKit
import RxCocoa

protocol MainNavigator: AnyObject {
    func toMain()
    func toCreateProject(updateTrigger: PublishRelay<Void>)
    func toUpdateProject(_ project: Project, updateTrigger: PublishRelay<Void>)
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
    
    func toCreateProject(updateTrigger: PublishRelay<Void>) {
        let createProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let createProjectViewModel = CreateProjectViewModel(
            navigator: createProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Cancel",
            updateTrigger: updateTrigger,
            sourceProject: nil
        )
        let createProjectViewController = EditProjectViewController(
            viewModel: createProjectViewModel
        )
        let createProjectNavigationController = UINavigationController(
            rootViewController: createProjectViewController
        )
        
        createProjectNavigationController.modalPresentationStyle = .formSheet
        
        self.navigationController.present(createProjectNavigationController, animated: true)
    }
    
    func toUpdateProject(_ project: Project, updateTrigger: PublishRelay<Void>) {
        let updateProjectNavigator = DefaultEditProjectNavigator(
            navigationController: self.navigationController
        )
        let updateProjectViewModel = UpdateProjectViewModel(
            navigator: updateProjectNavigator,
            useCase: coreDataService.makeProjectListUseCase(),
            leftBarButtonTitle: "Edit",
            updateTrigger: updateTrigger,
            sourceProject: project
        )
        let updateProjectViewController = EditProjectViewController(
            viewModel: updateProjectViewModel
        )
        let updateProjectNavigationController = UINavigationController(
            rootViewController: updateProjectViewController
        )
        
        updateProjectNavigationController.modalPresentationStyle = .formSheet
        
        self.navigationController.present(updateProjectNavigationController, animated: true)
    }
}
