//
//  FeedMapper.swift
//  eurosport-core
//
//  Created by IT on 01/12/2021.
//  Copyright © 2021 Marouane Youssef ©. All rights reserved.
//

import Foundation

final class Mapper {
    
    static func map<T: Decodable>(_ data: Data) -> Result<T, Error>{
        do {
            let feed = try JSONDecoder().decode(T.self, from: data)
            return .success(feed)
        } catch {
            return .failure(error)
        }
    }
}
