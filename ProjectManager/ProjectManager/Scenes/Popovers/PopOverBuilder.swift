//
//  PopOverBuilder.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/13.
//

import UIKit

enum PopOverBuilderError: Error {
    case propertiesNotConfigured
}

final class ChangeStatePopOverBuilder {
    struct PopOverProperties {
        var sourceView: UIView?
        var permittedArrowDirections: UIPopoverArrowDirection?
        var preferredContentSize: CGSize?
    }
    
    private let presentingViewController: UIViewController
    private var popOverProperties: PopOverProperties = .init()
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func withSourceView(_ view: UIView?) -> ChangeStatePopOverBuilder {
        popOverProperties.sourceView = view
        return self
    }
    
    func arrowDirections(_ directions: UIPopoverArrowDirection) -> ChangeStatePopOverBuilder {
        popOverProperties.permittedArrowDirections = directions
        return self
    }
    
    func preferredContentSize(_ size: CGSize) -> ChangeStatePopOverBuilder {
        popOverProperties.preferredContentSize = size
        return self
    }
    
    func show(with viewModel: ChangeStateViewModel) throws {
        guard let sourceView = popOverProperties.sourceView,
              let arrowDirections = popOverProperties.permittedArrowDirections,
              let preferredContentsSize = popOverProperties.preferredContentSize else {
            throw PopOverBuilderError.propertiesNotConfigured
        }
        
        let sourceRect = CGRect(origin: CGPoint(x: sourceView.bounds.midX,
                                                y: sourceView.bounds.midY),
                                size: .zero)
        
        let popOver = ChangeStateViewController(viewModel: viewModel)
        popOver.modalPresentationStyle = .popover
        popOver.preferredContentSize = preferredContentsSize
        popOver.popoverPresentationController?.sourceView = popOverProperties.sourceView
        popOver.popoverPresentationController?.sourceRect = sourceRect
        popOver.popoverPresentationController?.permittedArrowDirections = arrowDirections
        
        presentingViewController.present(popOver, animated: true)
    }
}
