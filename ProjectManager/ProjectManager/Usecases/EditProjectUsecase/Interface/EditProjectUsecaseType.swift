//
//  EditProjectUsecaseType.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/29.
//

protocol EditProjectUsecaseType {
    typealias InputText = (title: String, body: String)
    
    var leftButtonTitle: String { get }
    var sourceProject: Project? { get }
    
    func check(inputText: InputText) -> Bool
}

extension EditProjectUsecaseType {
    func check(inputText: InputText) -> Bool {
        let isTitleEdited = inputText.title != ""
        let isBodyEdited = inputText.body != ""

        return isTitleEdited || isBodyEdited
    }
}
