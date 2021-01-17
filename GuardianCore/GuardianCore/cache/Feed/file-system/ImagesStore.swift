//
//  HardDiskStore.swift
//  eurosport-core
//
//  Created by IT on 03/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

public final class ImagesStore: ImageDataStore {
    private let queue = DispatchQueue(label: "\(ImagesStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let cache: NSCache<NSString, NSData>

    private enum Error: Swift.Error {
        case notFound
        case badImageType
        case nameNotFound
    }

    public init(cache: NSCache<NSString, NSData>) {
        self.cache = cache
    }

    public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        let cache = self.cache
        queue.async {
            guard let name = url.pathComponents.last, let img = cache.object(forKey: NSString(string: name)) else {
                return completion(.failure(Error.notFound))
            }

            let data = img as Data
            let result: RetrievalResult = .success(data)
            completion(result)
        }
    }

    public func insert(_ image: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        let imageData = image as NSData
        guard let name = url.pathComponents.last else { return completion(.failure(Error.nameNotFound)) }

        let cache = self.cache
        queue.async(flags: .barrier) {
            cache.setObject(imageData, forKey: NSString(string: name))
            completion(.success(()))
        }
    }
}
