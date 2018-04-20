//
//  FlickrPhoto.swift
//  FlickrPickr
//
//  Created by Emre HAVAN on 21.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import Foundation
import SwiftyJSON


struct FlickrPhoto {
    let farm: String
    let server: String
    let id: String
    let secret: String
    var random = 0
    
    init(userJson: JSON) {
        // User might try the same tag over and over again, since api turns the same image as the first image of the response, using random number to acquire different image from the response.
        self.random = Int(arc4random_uniform(100))
        self.farm = userJson["photos"]["photo"][random]["farm"].stringValue
        self.server = userJson["photos"]["photo"][random]["server"].stringValue
        self.id = userJson["photos"]["photo"][random]["id"].stringValue
        self.secret = userJson["photos"]["photo"][random]["secret"].stringValue
    }
}

