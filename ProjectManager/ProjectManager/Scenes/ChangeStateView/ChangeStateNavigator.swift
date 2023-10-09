//
//  ChangeStateNavigator.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/26.
//

import UIKit

protocol ChangeStateNavigator {
    func toMain()
}

final class DefaultChangeStateNavigator: ChangeStateNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMain() {
        navigationController.dismiss(animated: true)
    }
}
