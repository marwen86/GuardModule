//
//  AppDelegate.swift
//  Guardian
//
//  Created by Youssef Marouane on 17/01/2021.
//

import UIKit
import GuardianCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var remoteFeedLoader: RemoteFeedLoader?
    var localFeedLoader: LocalFeedLoader?
    var remoteImageLoader: RemoteFeedImageDataLoader?
    let localStoreURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Guardian.store")
    
    let localDetailStoreURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("GuardianDetail.store")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //https://content.guardianapis.com/search?show-fields=headline,thumbnail&page-size=50&q=football%20and%20brexit&api-key=b910f9e7-183e-4041-893c-76456b317c44
        
        //https://content.guardianapis.com/football/2020/dec/28/football-and-brexit-a-guide-to-the-new-rules?show-fields=main,body,headline,thumbnail&api-key=b910f9e7-183e-4041-893c-76456b317c44
        
//        let remoteURL = URL(string: "https://content.guardianapis.com/search?show-fields=headline,thumbnail&page-size=50&q=football%20and%20brexit&api-key=b910f9e7-183e-4041-893c-76456b317c44")!
//
//        =
        let config = ApiDataNetworkConfig(baseURL: URL(string: "https://content.guardianapis.com")!,
                                          queryParameters: ["api-key": "b910f9e7-183e-4041-893c-76456b317c44",
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let client = DefaultNetworkService(config: config)
        let endPoint = APIEndpoints.getfeed()

        self.remoteFeedLoader = RemoteFeedLoader(endpoint: endPoint, client: client)
        remoteImageLoader = RemoteFeedImageDataLoader(client: client)

        let localStore = CodableFeedStore(storeURL: localStoreURL)

        localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
       
        let localCacheStore = ImagesStore(cache: NSCache<NSString, NSData>())
        let localImageLoader = LocalImageDataLoader(store: localCacheStore)
        
        self.localFeedLoader?.load(completion: { result in
            print("result")
        })
        
        self.remoteFeedLoader?.load(endpoint: endPoint) { result in
            switch result {
            case .success(let feed):
                self.localFeedLoader?.save(feed, completion: { result in
                    print("result")
                })
                let items = feed.items
                print("items")
            
            default:
                break
            }
        }
        
        remoteImageLoader?.loadImageData(from: URL(string: "https://media.guim.co.uk/cbe5373efa1e851be1a0f74a94df188d994dd856/252_257_1804_1082/500.jpg")!) { result in
            print(result)
        }
        
        

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

