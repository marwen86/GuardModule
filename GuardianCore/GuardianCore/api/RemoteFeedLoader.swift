//
//  RemoteFeedLoader.swift
//  eurosport-core
//
//  Created by IT on 30/11/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    public typealias Result = FeedLoader.Result
    let endpoint: Requestable
    let client: NetworkService

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(endpoint: Requestable, client: NetworkService) {
        self.endpoint = endpoint
        self.client = client
    }

    public func load(endpoint: Requestable, completion: @escaping (Result) -> Void) {
        client.request(endpoint: endpoint) {[weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard  let data = data else {
                    completion(.failure(Error.invalidData))
                    return
                }
                completion(Mapper.map(data))
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        }
    }
}
