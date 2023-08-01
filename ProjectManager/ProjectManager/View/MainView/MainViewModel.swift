//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/12.
//

import Foundation
import RxSwift

final class MainViewModel {
    private var children: [Project.State: ProjectListViewModel] = [:]
    
    func addChildren(_ children: [ProjectListViewModel]) {
        children.forEach { child in
            self.children[child.projectState] = child
        }
    }
}
