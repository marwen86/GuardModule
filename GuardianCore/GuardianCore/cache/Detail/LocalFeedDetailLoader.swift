//
//  LocalFeedLoader.swift
//  eurosport-core
//
//  Created by IT on 02/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public final class LocalFeedDetailLoader {
    private let store: FeedDetailStore
    private let currentDate: () -> Date
    
    public init(store: FeedDetailStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedDetailLoader: FeedDetailCache {
    public typealias SaveResult = FeedDetailCache.Result
    
    public func save(_ feed: FeedDetail, completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] deletionResult in
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(feed, with: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Helper
    
    private func cache( _ feed: FeedDetail, with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.entity, timestamp: self.currentDate(), completion: { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        })
    }
}

extension LocalFeedDetailLoader: FeedDetailLoader {
    public typealias LoadResult = FeedDetailLoader.Result
    
    public func load(endpoint: Requestable, completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(.some(cache)) where FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.feed.model))
                
            case .success:
                completion(.success(.empty))
            }
        }
    }
}


extension LocalFeedDetailLoader {
    public typealias ValidationResult = Result<Void, Error>
    
    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)
                
            case let .success(.some(cache)) where !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed(completion: completion)
                
            case .success:
                completion(.success(()))
            }        }
    }
}

private extension FeedDetail {
    var entity: FeedDetailEntity {
        return FeedDetailEntity(response: response.entity)
    }
}

private extension ResponseDetail {
    var entity: ResponseDetailEntity {
        .init(content: content.entity)
    }
}

private extension Content {
    var entity: ContentEntity {
        .init(fields: fields.entity)
    }
}

private extension FieldsDetail {
    var entity: FieldsDetailEntity {
        .init(headline: headline, main: main)
    }
}

//To Model
private extension FeedDetailEntity {
    var model: FeedDetail {
        .init(response: response.model)
    }
}

private extension ResponseDetailEntity {
    var model: ResponseDetail{
        ResponseDetail(content: content.model)
    }
}

private extension ContentEntity {
    var model: Content {
        .init(fields: fields.model)
    }
}

private extension FieldsDetailEntity {
    var model: FieldsDetail {
        .init(headline: headline, main: main)
    }
}


