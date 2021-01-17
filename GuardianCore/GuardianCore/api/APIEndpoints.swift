//
//  APIEndpoints.swift
//  GuardianCore
//
//  Created by Youssef Marouane on 17/01/2021.
//

import Foundation
public struct APIEndpoints {
    
    public static func getfeed() -> Endpoint {
        return Endpoint(path: "search?",
                        method: .get,
                        queryParameters: ["show-fields": "headline,thumbnail",
                                          "page-size": "50",
                                          "q": "football and brexit"])
        
    }
    
    public static func getfeedDetail() -> Endpoint {
        return Endpoint(path: "",
                        method: .get,
                        queryParameters: ["show-fields": "main,body,headlin"])
        
    }
}
