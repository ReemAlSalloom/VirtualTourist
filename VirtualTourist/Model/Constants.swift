//
//  Constants.swift
//  VirtualTourist
//
//  Created by Reem Saloom on 2/27/19.
//  Copyright © 2019 Reem AlSalloom. All rights reserved.
//

import Foundation

struct Constants {
    static let FILCKR_URL = "https://api.flickr.com/services/rest/"
    static let FILCKR_METHOD = "flickr.photos.search"
    static let API_KEY = "af9404d9cb059882f7c1ca214100d462"
}

struct FParams{
    var latitude:Double
    var longitude:Double
    var page:Int
    func getUrl() -> URL{
        var url =  "\(Constants.FILCKR_URL)?method=\(Constants.FILCKR_METHOD)"
        url += "&api_key=\(Constants.API_KEY)"
        url += "&format=json"
        url += "&nojsoncallback=1"
        url += "&per_page=10"
        url += "&page=\(page)"
        url += "&lat=\(latitude)"
        url += "&lon=\(longitude)"
        return URL(string: url)!
    }
}
