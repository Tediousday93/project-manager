//
//  HistoryPopOverBuilder.swift
//  ProjectManager
//
//  Created by Rowan on 2023/10/23.
//

import UIKit

final class HistoryPopOverBuilder: PopOverBuilderType {
    typealias ViewModel = HistoryViewModel
    
    struct PopOverProperties {
        var sourceView: UIView?
        var permittedArrowDirections: UIPopoverArrowDirection?
        var preferredContentSize: CGSize?
    }
    
    private var popOverProperties: PopOverProperties = .init()
    private let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func withSourceView(_ view: UIView?) -> Self {
        popOverProperties.sourceView = view
        return self
    }
    
    func arrowDirections(_ directions: UIPopoverArrowDirection) -> Self {
        popOverProperties.permittedArrowDirections = directions
        return self
    }
    
    func preferredContentSize(_ size: CGSize) -> Self {
        popOverProperties.preferredContentSize = size
        return self
    }
    
    func show(with viewModel: ViewModel) throws {
        guard let sourceView = popOverProperties.sourceView,
              let arrowDirections = popOverProperties.permittedArrowDirections,
              let preferredContentsSize = popOverProperties.preferredContentSize else {
            throw PopOverBuilderError.propertiesNotConfigured
        }
        
        let sourceRect = CGRect(origin: CGPoint(x: sourceView.bounds.midX,
                                                y: sourceView.bounds.maxY),
                                size: .zero)
        
        let popOver = HistoryViewController(viewModel: viewModel)
        popOver.modalPresentationStyle = .popover
        popOver.preferredContentSize = preferredContentsSize
        popOver.popoverPresentationController?.sourceView = popOverProperties.sourceView
        popOver.popoverPresentationController?.sourceRect = sourceRect
        popOver.popoverPresentationController?.permittedArrowDirections = arrowDirections
        
        presentingViewController.present(popOver, animated: true)
        popOverProperties = .init()
    }
}
