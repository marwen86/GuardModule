//
//  DefaultFeedDetailLoaderDecorator.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
public final class DefaultFeedDetailLoaderDecorator: FeedDetailLoader {
    
    private let decoratee: FeedDetailLoader
    private let cache: FeedDetailCache
    
    public init(decoratee: FeedDetailLoader, cache: FeedDetailCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(endpoint: Requestable, completion: @escaping (FeedDetailLoader.Result) -> Void) {
        decoratee.load(endpoint: endpoint) { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }

}

private extension FeedDetailCache {
    func saveIgnoringResult(_ feed: FeedDetail) {
        save(feed) { _ in }
    }
}
