//
//  Feed.swift
//  eurosport-core
//
//  Created by IT on 30/11/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

// MARK: - Feed
public struct Feed: Codable, Equatable {
    public let response: Response

    public init(response: Response) {
        self.response = response
    }

    public static let empty: Feed = Feed(response: Response.empty)
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
}

public struct Response: Codable, Equatable {
    public let results: [Article]
    
    public init(results: [Article]) {
        self.results = results
    }
    
    public static let empty: Response = Response(results: [])
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

public struct Article: Codable, Equatable {
    
    let type : String
    let sectionName : String
    let webPublicationDate : String
    let webUrl : String
    let fields: Fields
    
    private enum CodingKeys: String, CodingKey {
        case type
        case sectionName
        case webPublicationDate
        case webUrl
        case fields
    }
    
    public init(type: String, sectionName: String, webPublicationDate: String, webUrl: String, fields: Fields) {
        self.type = type
        self.sectionName = sectionName
        self.webPublicationDate = webPublicationDate
        self.webUrl = webUrl
        self.fields = fields
    }
}

public struct Fields:  Codable, Equatable {
    let headline : String
    let thumbnail : String
    
    public init(headline: String, thumbnail: String) {
        self.headline = headline
        self.thumbnail = thumbnail
    }
}


