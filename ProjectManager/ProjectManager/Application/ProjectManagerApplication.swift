//
//  ProjectManagerApplication.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/19.
//

import Foundation
import UIKit

final class ProjectManagerApplication {
    static let shared = ProjectManagerApplication()
    
    private let cdUseCaseProvider: CDUseCaseProvider
    
    private init() {
        self.cdUseCaseProvider = CDUseCaseProvider()
    }
    
    func configureMainUI(in window: UIWindow?) {
        let navigationController = UINavigationController()
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemGray5
        barAppearance.shadowColor = .clear
        navigationController.navigationBar.scrollEdgeAppearance = barAppearance
        
        let mainNavigator = DefaultMainNavigator(coreDataService: cdUseCaseProvider,
                                                 navigationController: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        mainNavigator.toMain()
    }
}
