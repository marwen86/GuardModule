//
//  LocalFeedLoader.swift
//  eurosport-core
//
//  Created by IT on 02/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader: FeedCache {
    public typealias SaveResult = FeedCache.Result
    
    public func save(_ feed: Feed, completion: @escaping (SaveResult) -> Void) {
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
    
    private func cache( _ feed: Feed, with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.entity, timestamp: self.currentDate(), completion: { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        })
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
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


extension LocalFeedLoader {
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

private extension Feed {
    var entity: FeedEntity {
        return FeedEntity(response: response.entity)
    }
}

private extension Response{
    var entity: ResponseEntity {
        .init(results: results.entities)
    }
}

private extension Array where Element == Article {
    var entities: [ArticleEntity] {
        map {
            ArticleEntity(type: $0.type,
                          sectionName: $0.sectionName,
                          webPublicationDate: $0.webPublicationDate,
                          apiUrl: $0.apiUrl,
                          fields: $0.fields.entity)
        }
    }
}

private extension Fields {
    var entity: FieldsEntity {
        .init(headline: headline, thumbnail: thumbnail)
    }
}


private extension FeedEntity {
    var model: Feed {
        return Feed(response: response.model)
    }
}

private extension ResponseEntity {
    var model: Response{
        .init(results: results.models)
    }
}

private extension Array where Element == ArticleEntity {
    var models: [Article] {
        map {
            Article(type: $0.type,
                    sectionName: $0.sectionName,
                    webPublicationDate: $0.webPublicationDate,
                    apiUrl: $0.apiUrl,
                    fields: $0.fields.model)
        }
    }
}

private extension FieldsEntity {
    var model: Fields {
        .init(headline: headline, thumbnail: thumbnail)
    }
}


