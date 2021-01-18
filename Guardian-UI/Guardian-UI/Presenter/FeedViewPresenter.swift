//
//  FeedViewAdapter.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

final class FeedViewPresenter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedItemImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedItemImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let intercator = FeedCellInteractor(model: model, imageLoader: imageLoader)
            let view = FeedItemCellController(intercator: intercator)
            intercator.presenter = FeedItemPresenter(
                view: WeakRefVirtualProxy(view))
            return view
        }
    }
}
