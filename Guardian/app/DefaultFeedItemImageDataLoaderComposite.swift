//
//  Copyright © 2019 Marouane Youssef. All rights reserved.
//

import Foundation

public class DefaultFeedItemImageDataLoaderComposite: FeedItemImageDataLoader {
	private let primary: FeedItemImageDataLoader
	private let fallback: FeedItemImageDataLoader

	public init(primary: FeedItemImageDataLoader, fallback: FeedItemImageDataLoader) {
		self.primary = primary
		self.fallback = fallback
	}
	
	private class TaskWrapper: FeedImageDataLoaderTask {
		var wrapped: FeedImageDataLoaderTask?
		
		func cancel() {
			wrapped?.cancel()
		}
	}

	public func loadImageData(from url: URL, completion: @escaping (FeedItemImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		let task = TaskWrapper()
		task.wrapped = primary.loadImageData(from: url) { [weak self] result in
			switch result {
			case .success:
				completion(result)
			case .failure:
				task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
			}
		}
		return task
	}
}
