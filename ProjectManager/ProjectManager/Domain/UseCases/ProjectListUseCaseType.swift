//
//  ProjectListUseCaseType.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

import RxSwift

protocol ProjectListUseCaseType {
    func projectList(for state: Project.State?) -> Observable<[Project]>
    func create(project: Project) throws
    func update(project: Project) throws
    func delete(project: Project) throws
}