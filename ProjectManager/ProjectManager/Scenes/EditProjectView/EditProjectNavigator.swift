//
//  EditProjectNavigator.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import UIKit

protocol EditProjectNavigator {
    func toMain()
}

final class DefaultEditProjectNavigator: EditProjectNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMain() {
        navigationController.dismiss(animated: true)
    }
}
