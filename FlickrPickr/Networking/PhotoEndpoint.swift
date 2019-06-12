//
//  PhotoEndpoint.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 12.06.2019.
//  Copyright © 2019 Emre HAVAN. All rights reserved.
//

import Foundation

enum PhotoEndpoint {
    case tag(tagID: String?)
}

extension PhotoEndpoint: Endpoint {
    
    var request: URLRequest? {
        return request(forPath: "/services/rest/")
    }
    
    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = []
        
        switch self {
        case .tag(let tag):
            guard let tagName = tag else { return nil }
            items.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
            items.append(URLQueryItem(name: "api_key", value: NetworkManager.Constants.apiKey))
            items.append(URLQueryItem(name: "tags", value: tagName))
            items.append(URLQueryItem(name: "privacy_filter", value: "1"))
            items.append(URLQueryItem(name: "format", value: "json"))
            items.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        }
        
        return items
    }
}
