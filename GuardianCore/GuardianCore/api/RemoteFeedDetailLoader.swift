//
//  RemoteFeedDetailLoader.swift
//  GuardianCore
//
//  Created by Youssef Marouane on 17/01/2021.
//

import Foundation

public final class RemoteFeedDetailLoader: FeedDetailLoader {
    public typealias Result = FeedDetailLoader.Result
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
        let url = URL(string: "https://content.guardianapis.com/football/live/2020/oct/31/burnley-v-chelsea-plus-football-league-and-more-live?show-fields=main,body,headline,thumbnail&api-key=b910f9e7-183e-4041-893c-76456b317c44")
        client.directRequest(endpoint: url!) {[weak self] result in
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
