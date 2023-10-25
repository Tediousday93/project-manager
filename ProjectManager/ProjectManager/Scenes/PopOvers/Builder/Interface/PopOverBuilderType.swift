//
//  PopOverBuilderType.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/23.
//

import UIKit

protocol PopOverBuilderType {
    associatedtype PopOverProperties
    associatedtype ViewModel
    
    func withSourceView(_ view: UIView?) -> Self
    func arrowDirections(_ directions: UIPopoverArrowDirection) -> Self
    func preferredContentSize(_ size: CGSize) -> Self
    func show(with viewModel: ViewModel) throws
}
