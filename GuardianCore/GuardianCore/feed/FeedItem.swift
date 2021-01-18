//
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public struct FeedItem {
    
    public var webUrl: String
    public var headline: String
    public var thumbnail: String
    public var webPublicationDate: String
    
    public init(webUrl: String, headline: String, thumbnail: String, webPublicationDate: String) {
        self.webUrl = webUrl
        self.headline = headline
        self.thumbnail = thumbnail
        self.webPublicationDate = webPublicationDate
    }
}

extension Feed {
    public var items: [FeedItem] {
        return response.results.map { article in
            FeedItem(webUrl: article.webUrl,
                     headline: article.fields.headline,
                     thumbnail: article.fields.thumbnail,
                     webPublicationDate: article.webPublicationDate.formattedDate)
        }.sorted(by: sortChronologically)
    }

    private var sortChronologically: (FeedItem, FeedItem) -> Bool {
        { lhs, rhs -> Bool in lhs.webPublicationDate.toDate > rhs.webPublicationDate.toDate }
    }
}

private extension String {
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let showDate = inputFormatter.date(from: self) else { return "" }
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultString = inputFormatter.string(from: showDate)
        return resultString
    }
    
    var toDate: Date {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return inputFormatter.date(from: self) ?? Date()
    }
}
