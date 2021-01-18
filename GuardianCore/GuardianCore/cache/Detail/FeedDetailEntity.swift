//
//  FeedEntity.swift
//  eurosport-core
//
//  Created by IT on 02/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

// MARK: - Feed
public struct FeedDetailEntity: Codable, Equatable {
    public let response: ResponseDetailEntity

    public init(response: ResponseDetailEntity) {
        self.response = response
    }

    public static let empty: FeedDetailEntity = FeedDetailEntity(response: ResponseDetailEntity.empty)
}

public struct ResponseDetailEntity: Codable, Equatable {

    public let content: ContentEntity
    
    public init(content: ContentEntity) {
        self.content = content
    }
    
    
    public static let empty: ResponseDetailEntity = ResponseDetailEntity(content: ContentEntity.empty)
}

public struct ContentEntity: Codable, Equatable {
    let fields : FieldsDetailEntity
    
    public init(fields: FieldsDetailEntity) {
        self.fields = fields
    }
    
    public static let empty: ContentEntity = ContentEntity(fields: FieldsDetailEntity.empty)
}

public struct FieldsDetailEntity:  Codable, Equatable {
    let main : String
    let body: String
    
    public init(main: String, body: String) {
        self.main = main
        self.body = body
    }
    
    public static let empty: FieldsDetailEntity = FieldsDetailEntity(main: "", body: "")
}


