//
//  ViewModelType.swift
//  ProjectManager
//
//  Created by Rowan on 2023/07/13.
//

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
