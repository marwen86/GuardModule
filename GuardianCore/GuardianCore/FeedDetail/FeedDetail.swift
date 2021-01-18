//
//  FeedDetail.swift
//  eurosport-core
//
//  Created by IT on 30/11/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

// MARK: - Feed
public struct FeedDetail: Codable, Equatable {
    public let response: ResponseDetail

    public init(response: ResponseDetail) {
        self.response = response
    }

    public static let empty: FeedDetail = FeedDetail(response: ResponseDetail.empty)
}

public struct ResponseDetail: Codable, Equatable {
    public let content: Content
    
    public static let empty: ResponseDetail = ResponseDetail(content: Content.empty)
}

public struct Content: Codable, Equatable {
    let fields : FieldsDetail
    public static let empty: Content = Content(fields: FieldsDetail.empty)
}

public struct FieldsDetail:  Codable, Equatable {
    let main : String
    let body: String
    
    internal init(main: String, body: String) {
        self.main = main
        self.body = body
    }
    public static let empty: FieldsDetail = FieldsDetail(main: "", body: "")
}


