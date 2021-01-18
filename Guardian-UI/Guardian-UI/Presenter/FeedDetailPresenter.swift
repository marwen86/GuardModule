//
//  FeedDetailPresenter.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import GuardianCore

public protocol FeedDetailView {
    func display(_ viewModel: FeedDetailViewModel)
}

class FeedDetailPresenter {
    
    private let feedView: FeedDetailView
    private let errorView: FeedErrorView
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                tableName: "Feed",
                bundle: Bundle(for: FeedPresenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public init(feedView: FeedDetailView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_DETAIL_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedDetailPresenter.self),
            comment: "Title for the feed view")
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
    }
    
    public func didFinishLoadingFeed(with feed: FeedDetail) {
        feedView.display(FeedDetailViewModel(feedDetail: feed.item))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
    }
}
