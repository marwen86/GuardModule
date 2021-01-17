//
//  Copyright © 2021 Marouane Youssef. All rights reserved.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedItemImageDataLoader {
    let client: NetworkService
    
    public init(client: NetworkService) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedItemImageDataLoader.Result) -> Void)?
        
        var wrapped: NetworkCancellable?
        
        init(_ completion: @escaping (FeedItemImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedItemImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedItemImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        
        task.wrapped = client.directRequest(endpoint: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                            .mapError { _ in Error.connectivity }
                            .flatMap { data in
                                guard let data = data else {
                                    return .failure(Error.invalidData)
                                    
                                }
                                return .success(data)
                            })
        }
        
        return task
    }
}
