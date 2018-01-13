//
//  RestaurantDataProvider.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import Foundation

protocol RestaurantDataProvider {
    //They should all be singletons
    static var shared:RestaurantDataProvider {
        get
    }
    var config:URLSessionConfiguration! { get }
    func getRestaurantsFor(searchTerm:String, completion:([Restaurant]?,Error?) -> Void)
}

class FakeDataProvider : RestaurantDataProvider {
    static var shared: RestaurantDataProvider = FakeDataProvider() as RestaurantDataProvider
    
    var config: URLSessionConfiguration!
    
    func getRestaurantsFor(searchTerm: String, completion: ([Restaurant]?, Error?) -> Void) {
        completion([
            Restaurant.init(name: "Fake Ethiopian 1", price: 1, rating: 1, review: "It's OK"),
            Restaurant.init(name: "Fake Ethiopian 2", price: 3, rating: 3, review: "This one is better"),
            Restaurant.init(name: "Fake Ethiopian 3", price: 2, rating: 4, review: "This is the best")
            ], nil)
    }

}
