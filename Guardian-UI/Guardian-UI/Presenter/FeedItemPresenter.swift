//
//  FeedItemPresenter.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import UIKit
import GuardianCore

public protocol FeedItemView {
    func display(_ model: FeedItemViewModel)
}

public final class FeedItemPresenter {
    
    private let view: FeedItemView
    
    public init(view: FeedItemView) {
        self.view = view
    }
    
    public func didStartLoadingImageData(for model: FeedItem) {
        let model = FeedItemViewModel(image: nil, title: model.headline, publicationDate: model.webPublicationDate.toString)
        view.display(model)
    }
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedItem) {
        let image = UIImage(data:data,scale:1.0)
        let model = FeedItemViewModel(image: image, title: model.headline, publicationDate: model.webPublicationDate.toString)
        view.display(model)
    }
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedItem) {
        let model = FeedItemViewModel(image: nil, title: model.headline, publicationDate: model.webPublicationDate.toString)
        view.display(model)
    }
}
