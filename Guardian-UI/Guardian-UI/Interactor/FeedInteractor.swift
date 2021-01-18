//
//  FeedInteractor.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

protocol FeedInteractorProtocol {
    func didRequestFeedRefresh()
}

final class FeedInteractor: FeedInteractorProtocol {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        let endPoint = APIEndpoints.getfeed()
        feedLoader.load(endpoint: endPoint) { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
