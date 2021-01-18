//
//  FeedRouter.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import UIKit
import GuardianCore

class FeedRouter {
    private var controller: UINavigationController
    
    init(controller: UINavigationController) {
        self.controller = controller
    }
}

extension FeedRouter: FeedRouterLogic {
    func goToDetail(url: URL?) {
        //Create Detail View and push it
        guard let url = url else { return }
        let localStoreURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("GuardianDetail.store")
        URL(string: url.absoluteString)
        let config = ApiDataNetworkConfig(baseURL: url,
                                          queryParameters: ["api-key": "b910f9e7-183e-4041-893c-76456b317c",
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let client = DefaultNetworkService(config: config)
        let endPoint = APIEndpoints.getfeedDetail()
        let remoteFeedLoader = RemoteFeedDetailLoader(endpoint: endPoint, client: client)
        let localStore = CodableFeedDetailStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedDetailLoader(store: localStore, currentDate: Date.init)
        
        let feedDetailViewController = FeedUIComposer.feedDetailComposedWith(
            feedLoader: DefaultFeedDetailLoaderComposite(
                primary: DefaultFeedDetailLoaderDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader
                ),
                fallback: localFeedLoader
            ))
        self.controller.pushViewController(feedDetailViewController, animated: true)
    }
}
