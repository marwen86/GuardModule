//
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public struct FeedItem {
    
    public var apiUrl: String
    public var headline: String
    public var thumbnail: String
    public var webPublicationDate: Date
    
    public init(apiUrl: String, headline: String, thumbnail: String, webPublicationDate: Date) {
        self.apiUrl = apiUrl
        self.headline = headline
        self.thumbnail = thumbnail
        self.webPublicationDate = webPublicationDate
    }
}

extension Feed {
    public var items: [FeedItem] {
        return response.results.map { article in
            FeedItem(apiUrl: article.apiUrl,
                     headline: article.fields.headline,
                     thumbnail: article.fields.thumbnail,
                     webPublicationDate: article.webPublicationDate.toDate)
        }.sorted(by: sortChronologically)
    }

    private var sortChronologically: (FeedItem, FeedItem) -> Bool {
        { lhs, rhs -> Bool in lhs.webPublicationDate > rhs.webPublicationDate }
    }
}
private extension String {
    var toDate: Date {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return inputFormatter.date(from: self) ?? Date()
    }
}

