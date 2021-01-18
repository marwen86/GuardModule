//
//  FeedCellInteractor.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

protocol FeedCellInteractorProtocol {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedCellInteractor: FeedCellInteractorProtocol {
    private let model: FeedItem
    private let imageLoader: FeedItemImageDataLoader
    private var task: FeedImageDataLoaderTask?
    
    var presenter: FeedItemPresenter?
    
    init(model: FeedItem, imageLoader: FeedItemImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        guard let url = URL(string: model.thumbnail) else { return }
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
