//
//  Copyright © 2019 Marouane Youssef. All rights reserved.
//

import Foundation
import GuardianCore

final class MainQueueDispatchDecorator<T> {
	private let decoratee: T
	
	init(decoratee: T) {
		self.decoratee = decoratee
	}
	
	func dispatch(completion: @escaping () -> Void) {
		guard Thread.isMainThread else {
			return DispatchQueue.main.async(execute: completion)
		}
		
		completion()
	}
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
    func load(endpoint: Requestable, completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(endpoint: endpoint) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: FeedDetailLoader where T == FeedDetailLoader {
    func load(endpoint: Requestable, completion: @escaping (FeedDetailLoader.Result) -> Void) {
        decoratee.load(endpoint: endpoint) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: FeedItemImageDataLoader where T == FeedItemImageDataLoader {
	func loadImageData(from url: URL, completion: @escaping (FeedItemImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		return decoratee.loadImageData(from: url) { [weak self] result in
			self?.dispatch { completion(result) }
		}
	}
}
