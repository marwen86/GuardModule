//
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public struct FeedDetailItem {
    public var main: String
}

extension FeedDetail {
    public var item: FeedDetailItem {
        .init(main: response.content.fields.main)
    }
}
