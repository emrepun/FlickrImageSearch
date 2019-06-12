//
//  Photo.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 12.06.2019.
//  Copyright © 2019 Emre HAVAN. All rights reserved.
//

import Foundation

class Response: Codable {
    var stat: String?
    var photos: Photos?
}

class Photos: Codable {
    var photo: [Photo]?
}

class Photo: Codable {
    var server: String?
    var farm: Int?
    var id: String?
    var secret: String?
    
    var imageString: String? {
        if let farm = farm, let server = server, let id = id, let secret = secret {
            return "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_n.jpg/"
        } else {
            return "https://i.imgur.com/uAhjMNd.jpg"
        }
        
    }
    
}
