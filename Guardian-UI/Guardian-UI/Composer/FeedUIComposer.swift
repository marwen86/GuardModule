//
//  FeedUIComposer.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import Foundation
import UIKit
import GuardianCore

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedItemImageDataLoader) -> FeedViewController {
        let interactor = FeedInteractor(feedLoader:
                                            MainQueueDispatchDecorator(decoratee: feedLoader))
        
        let feedController = makeFeedViewController(
            interactor: interactor,
            title: FeedPresenter.title
        )
        
        let presenterView = FeedViewPrsenter(
            controller: feedController,
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
        )
        
        let presenter = FeedPresenter(feedView: presenterView,
                       loadingView: WeakRefVirtualProxy(feedController),
                       errorView: WeakRefVirtualProxy(feedController))
        

        interactor.presenter = presenter
        return feedController
    }
    
    private static func makeFeedViewController(interactor: FeedInteractorProtocol, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "FeedStoryboard", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.interactor = interactor
        feedController.title = title
        return feedController
    }
}
