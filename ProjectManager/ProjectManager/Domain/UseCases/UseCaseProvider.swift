//
//  UseCaseProvider.swift
//  ProjectManager
//
//  Created by Rowan on 2023/09/14.
//

protocol UseCaseProvider {
    func makeProjectListUseCase() -> ProjectListUseCaseType
}
