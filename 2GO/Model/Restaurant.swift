//
//  Restaurant.swift
//  2GO
//
//  Created by Victor Li on 10/11/18.
//  Copyright © 2018 Pat Khai. All rights reserved.
//

import Foundation

struct Restaurant {
    let id: Int
    let name: String
    let photos: [String]
    let categories: [String]
    let address: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String
    let menuItems: [MenuItem]
//    let cartItems: [Cart]
    
    init(id: Int, name: String, photos: [String], categories: [String], address: String, latitude: Double, longitude: Double, phoneNumber: String, menuItems: [MenuItem]) {
        self.id = id
        self.name = name
        self.photos = photos
        self.categories = categories
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.menuItems = menuItems

    }
    
//    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, limit: Int?, offset: Int?, completion: @escaping ([Restaurant]?, Error?) -> Void) -> Void {
//        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, openNow: false, completion: completion)
//    }
}
