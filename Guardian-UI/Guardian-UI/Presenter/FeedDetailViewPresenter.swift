//
//  FeedDetailViewPrsenter.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

final class FeedDetailViewPresenter: FeedDetailView {
    
    private weak var controller: FeedDetailViewController?
    
    init(controller: FeedDetailViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: FeedDetailViewModel) {
        self.controller?.setView(viewModel)
    }
}
