//
//  FeedDetailLoader.swift
//  eurosport-core
//
//  Created by IT on 30/11/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public protocol FeedDetailLoader {
    typealias Result = Swift.Result<FeedDetail, Error>

    func load(endpoint: Requestable, completion: @escaping (Result) -> Void)
}
