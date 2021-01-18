//
//  WeakRefVirtualProxy.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedErrorView where T: FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedItemView where T: FeedItemView {
    func display(_ model: FeedItemViewModel) {
        object?.display(model)
    }
}
