//
//  Codable.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 2/27/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation

struct AlbumResponse : Codable {
    var photos : Photos
    var stat : String
}

struct Photos : Codable {
    var photo : [PhotoList]
}

struct PhotoList : Codable {
    var id : String
    var server : String
    var secret : String
    var farm : Int
    var url : String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
}
