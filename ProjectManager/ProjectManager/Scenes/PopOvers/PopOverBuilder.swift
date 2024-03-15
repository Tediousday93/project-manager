//
//  PopoverBuilder.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/13.
//

import UIKit

enum PopoverBuilderError: Error {
    case propertiesNotConfigured
}

protocol PopoverViewType: UIViewController {
    associatedtype ViewModel: ViewModelType
    
    init(viewModel: ViewModel)
}

final class PopoverBuilder<PopoverView: PopoverViewType> {
    struct PopoverProperties {
        var sourceView: UIView?
        var permittedArrowDirections: UIPopoverArrowDirection?
        var preferredContentSize: CGSize?
    }
    
    private let presentingViewController: UIViewController
    private var popoverProperties: PopoverProperties = .init()
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func withSourceView(_ view: UIView?) -> PopoverBuilder {
        popoverProperties.sourceView = view
        return self
    }
    
    func arrowDirections(_ directions: UIPopoverArrowDirection) -> PopoverBuilder {
        popoverProperties.permittedArrowDirections = directions
        return self
    }
    
    func preferredContentSize(_ size: CGSize) -> PopoverBuilder {
        popoverProperties.preferredContentSize = size
        return self
    }
    
    func show(with viewModel: PopoverView.ViewModel) throws {
        guard let sourceView = popoverProperties.sourceView,
              let arrowDirections = popoverProperties.permittedArrowDirections,
              let preferredContentsSize = popoverProperties.preferredContentSize else {
            throw PopoverBuilderError.propertiesNotConfigured
        }
        
        let sourceRect = CGRect(origin: CGPoint(x: sourceView.bounds.midX,
                                                y: sourceView.bounds.midY),
                                size: .zero)
        
        let popoverView = PopoverView(viewModel: viewModel)
        popoverView.modalPresentationStyle = .popover
        popoverView.preferredContentSize = preferredContentsSize
        popoverView.popoverPresentationController?.sourceView = popoverProperties.sourceView
        popoverView.popoverPresentationController?.sourceRect = sourceRect
        popoverView.popoverPresentationController?.permittedArrowDirections = arrowDirections
        
        presentingViewController.present(popoverView, animated: true)
    }
}
