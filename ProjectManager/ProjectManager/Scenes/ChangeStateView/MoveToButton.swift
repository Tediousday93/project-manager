//
//  MoveToButton.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/09.
//

import UIKit

final class MoveToButton: UIButton {
    private(set) var titleSuffix: String = ""
    
    func provide(titleSuffix: String) {
        self.titleSuffix = titleSuffix
        self.setTitle(Constants.title + titleSuffix, for: .normal)
    }
}

extension MoveToButton {
    private enum Constants {
        static let title: String = "Move to "
    }
}
