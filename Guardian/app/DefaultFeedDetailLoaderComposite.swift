//
//  DefaultFeedDetailLoaderComposite.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
public class DefaultFeedDetailLoaderComposite: FeedDetailLoader {
    
    private let primary: FeedDetailLoader
    private let fallback: FeedDetailLoader

    public init(primary: FeedDetailLoader, fallback: FeedDetailLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(endpoint: Requestable, completion: @escaping (FeedDetailLoader.Result) -> Void) {
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

