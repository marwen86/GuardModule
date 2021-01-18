//
//  Copyright © 2019 Marouane Youssef. All rights reserved.
//


public final class DefaultFeedLoaderDecorator: FeedLoader {
    
	private let decoratee: FeedLoader
	private let cache: FeedCache
	
	public init(decoratee: FeedLoader, cache: FeedCache) {
		self.decoratee = decoratee
		self.cache = cache
	}
    
    public func load(endpoint: Requestable, completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(endpoint: endpoint) { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }

}

private extension FeedCache {
	func saveIgnoringResult(_ feed: Feed) {
		save(feed) { _ in }
	}
}
