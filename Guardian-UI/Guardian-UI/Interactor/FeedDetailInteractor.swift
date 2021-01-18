//
//  FeedDetailInteractor.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

protocol FeedDetailInteractorProtocol {
    func didRequestFeedRefresh()
}

final class FeedDetailInteractor: FeedDetailInteractorProtocol {
    private let loader: FeedDetailLoader
    var presenter: FeedDetailPresenter?
    
    init(loader: FeedDetailLoader) {
        self.loader = loader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        let endPoint = APIEndpoints.getfeedDetail()
        loader.load(endpoint: endPoint) {[weak self] result in
            switch result {
            case let .success(detail):
                self?.presenter?.didFinishLoadingFeed(with: detail)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
        
        
    }
}
