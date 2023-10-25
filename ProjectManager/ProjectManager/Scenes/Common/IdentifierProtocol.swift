//
//  IdentifierProtocol.swift
//  ProjectManager
//
//  Created by Rowan on 2023/08/02.
//

protocol IdentifierProtocol: AnyObject {
    static var identifier: String { get }
}

extension IdentifierProtocol {
    static var identifier: String { return String(describing: self) }
}
