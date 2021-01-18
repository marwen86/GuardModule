//
//  Copyright © 2019 Marouane Youssef. All rights reserved.
//


public class DefaultFeedLoaderComposite: FeedLoader {
    
	private let primary: FeedLoader
	private let fallback: FeedLoader

	public init(primary: FeedLoader, fallback: FeedLoader) {
		self.primary = primary
		self.fallback = fallback
	}
    
    public func load(endpoint: Requestable, completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load(endpoint: endpoint) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(endpoint: endpoint, completion: completion)
            }
        }
    }
}
