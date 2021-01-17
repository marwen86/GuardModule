//
//  Copyright © 2021 Marouane Youssef. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
	typealias Result = Swift.Result<Void, Error>

	func save(_ image: Data, for url: URL, completion: @escaping (Result) -> Void)
}
