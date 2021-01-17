//
//  Copyright © 2021 Marouane Youssef. All rights reserved.
//

import Foundation

public final class LocalImageDataLoader {
    private let store: ImageDataStore

    public init(store: ImageDataStore) {
        self.store = store
    }
}

extension LocalImageDataLoader: FeedImageDataCache {
    public typealias SaveResult = FeedImageDataCache.Result

    public enum SaveError: Error {
        case failed
    }

    public func save(_ image: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(image, for: url) { [weak self] result in
            guard self != nil else { return }

            completion(result.mapError { _ in SaveError.failed })
        }
    }
}

extension LocalImageDataLoader: FeedItemImageDataLoader {
    public typealias LoadResult = FeedItemImageDataLoader.Result

    public enum LoadError: Error {
        case failed
        case notFound
    }

    private final class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completion: ((FeedItemImageDataLoader.Result) -> Void)?

        init(_ completion: @escaping (FeedItemImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedItemImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0 as Data) } ?? .failure(LoadError.notFound)
                })
        }
        return task
    }
}
