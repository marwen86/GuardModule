//
//  FeedLoader.swift
//  eurosport-core
//
//  Created by IT on 30/11/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<Feed, Error>
    
    func load(endpoint: Requestable, completion: @escaping (Result) -> Void)
}
