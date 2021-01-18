//
//  SceneDelegate.swift
//  Guardian
//
//  Created by Youssef Marouane on 17/01/2021.
//

import UIKit
import Guardian_UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let localStoreURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Guardian.store")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        let config = ApiDataNetworkConfig(baseURL: URL(string: "https://content.guardianapis.com")!,
                                          queryParameters: ["api-key": "b910f9e7-183e-4041-893c-76456b317c",
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let client = DefaultNetworkService(config: config)
        let endPoint = APIEndpoints.getfeed()
        
        let remoteFeedLoader = RemoteFeedLoader(endpoint: endPoint, client: client)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: client)
        
        let localStore = CodableFeedStore(storeURL: localStoreURL)
        
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        
        let localCacheStore = ImagesStore(cache: NSCache<NSString, NSData>())
        let localImageLoader = LocalImageDataLoader(store: localCacheStore)
        
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: DefaultFeedLoaderComposite(
                primary: DefaultFeedLoaderDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader
                ),
                fallback: localFeedLoader
            ),
            imageLoader: DefaultFeedItemImageDataLoaderComposite(
                primary: localImageLoader,
                fallback: DefaultFeedItemImageDataLoaderDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader
                )
            )
        )
        
        let navigationController = UINavigationController(rootViewController: feedViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.07992280275, green: 0.1072936282, blue: 0.3030902147, alpha: 1)
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let router = FeedRouter(controller: navigationController)
        feedViewController.router = router

        window?.rootViewController = navigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

