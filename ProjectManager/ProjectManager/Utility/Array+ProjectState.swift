//
//  Array+ProjectState.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/09.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Array where Element == Project.State {
    mutating func remove(where predicate: (Self.Element) -> Bool) {
        for state in self {
            guard let currentIndex = self.firstIndex(of: state) else {
                return
            }
            
            if predicate(state) == true {
                self.remove(at: currentIndex)
                break
            }
        }
    }
}
