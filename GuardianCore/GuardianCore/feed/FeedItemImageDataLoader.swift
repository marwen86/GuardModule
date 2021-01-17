//
//  Copyright © 2021 Marouane Youssef. All rights reserved.
//

import Foundation

public protocol FeedImageDataLoaderTask {
	func cancel()
}

public protocol FeedItemImageDataLoader {
	typealias Result = Swift.Result<Data, Error>
	
	func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
