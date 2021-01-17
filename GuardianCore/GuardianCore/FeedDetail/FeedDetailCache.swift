//
//  FeedDetailCache.swift
//  eurosport-core
//
//  Created by IT on 02/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public protocol FeedDetailCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: FeedDetail, completion: @escaping (Result) -> Void)
}
