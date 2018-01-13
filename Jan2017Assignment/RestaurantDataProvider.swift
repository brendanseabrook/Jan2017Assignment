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
    func getRestaurantsFor(searchTerm:String, completion:@escaping ([Restaurant]?,RestaurantDataProviderError?) -> Void)
}

enum RestaurantDataProviderError {
    case BadRequest
}

//I pulled this out of an existing project of mine
extension URL {
    public static func make(string:String, queryComponents:[String:String]) -> URL? {
        let parsedComponents = queryComponents.map { (key, value) -> String? in
            guard let encoded = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                return nil
            }
            return key + "=" + encoded
        }
        
        guard parsedComponents.count == queryComponents.count else {
            return nil
        }
        
        return URL(string: string + (parsedComponents.count > 0 ? "?" : "") + (parsedComponents as! [String]).joined(separator: "&"))
    }
}

class FakeDataProvider : RestaurantDataProvider {
    static var shared: RestaurantDataProvider = FakeDataProvider() as RestaurantDataProvider
    
    var config: URLSessionConfiguration!
    
    func getRestaurantsFor(searchTerm: String, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        completion([
            Restaurant.init(name: "Fake Ethiopian 1", price: 1, rating: 1, review: "It's OK"),
            Restaurant.init(name: "Fake Ethiopian 2", price: 3, rating: 3, review: "This one is better"),
            Restaurant.init(name: "Fake Ethiopian 3", price: 2, rating: 4, review: "This is the best")
            ], nil)
    }
}

class YelpDataProvider : RestaurantDataProvider {
    static var shared: RestaurantDataProvider = YelpDataProvider() as RestaurantDataProvider
    
    var config: URLSessionConfiguration!
    
    init() {
        config = URLSessionConfiguration.default
        //I know. Here is not a great place to put this, however I'm going to leave it here to keep it simple
        config.httpAdditionalHeaders = [
            "Authorization": "Bearer " + "qY92NeZMw__mYbfUN4gx_Naul1EZhy-Is3HHwL1-f9XB2VL_rb0ryDrd8iGDFslU4LAiKKwChj_tOahwW_aka1kDIQlW-InHxEZG9J3rL69I85rqrHW52KTjB3VYWnYx"
        ]
    }
    
    func getRestaurantsFor(searchTerm: String, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        guard let url = URL.make(string: "https://api.yelp.com/v3/businesses/search", queryComponents: [
                "term" : searchTerm,
                "location" : "Toronto"
            ]) else {
                completion(nil, .BadRequest)
                return
        }
        
        let session = URLSession(configuration: self.config)
        
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if data == nil || error != nil || (response as? HTTPURLResponse)?.statusCode != 400 {
                completion(nil, .BadRequest)
                return
            }
            
            //Turn all the data into [Restaurant]
            completion([], nil)
        })
        
        dataTask.resume()
    }

}
