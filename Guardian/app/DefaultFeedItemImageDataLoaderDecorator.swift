//
//  Copyright © 2019 Marouane Youssef. All rights reserved.
//

import Foundation

public final class DefaultFeedItemImageDataLoaderDecorator: FeedItemImageDataLoader {
	private let decoratee: FeedItemImageDataLoader
	private let cache: FeedImageDataCache

	public init(decoratee: FeedItemImageDataLoader, cache: FeedImageDataCache) {
		self.decoratee = decoratee
		self.cache = cache
	}
	
	public func loadImageData(from url: URL, completion: @escaping (FeedItemImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		return decoratee.loadImageData(from: url) { [weak self] result in
			completion(result.map { data in
				self?.cache.saveIgnoringResult(data, for: url)
				return data
			})
		}
	}
}

private extension FeedImageDataCache {
	func saveIgnoringResult(_ data: Data, for url: URL) {
		save(data, for: url) { _ in }
	}
}
