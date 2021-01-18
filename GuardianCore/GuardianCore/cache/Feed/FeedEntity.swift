//
//  FeedEntity.swift
//  eurosport-core
//
//  Created by IT on 02/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

// MARK: - Feed
public struct FeedEntity: Codable, Equatable {
    public let response: ResponseEntity

    public init(response: ResponseEntity) {
        self.response = response
    }

    public static let empty: FeedEntity = FeedEntity(response: ResponseEntity.empty)
}

public struct ResponseEntity: Codable, Equatable {
    public let results: [ArticleEntity]
    
    public init(results: [ArticleEntity]) {
        self.results = results
    }
    
    public static let empty: ResponseEntity = ResponseEntity(results: [])
}

public struct ArticleEntity: Codable, Equatable {
    
    let type : String
    let sectionName : String
    let webPublicationDate : String
    let apiUrl : String
    let fields: FieldsEntity
    
    public init(type: String, sectionName: String, webPublicationDate: String, apiUrl: String, fields: FieldsEntity) {
        self.type = type
        self.sectionName = sectionName
        self.webPublicationDate = webPublicationDate
        self.apiUrl = apiUrl
        self.fields = fields
    }
}

public struct FieldsEntity:  Codable, Equatable {
    let headline : String
    let thumbnail : String
    
    public init(headline: String, thumbnail: String) {
        self.headline = headline
        self.thumbnail = thumbnail
    }
}


