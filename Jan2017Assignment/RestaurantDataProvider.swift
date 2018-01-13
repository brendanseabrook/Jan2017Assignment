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
    func processResponse(data:Data, completion:@escaping ([Restaurant]?,RestaurantDataProviderError?) -> Void)
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
    func processResponse(data: Data, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        
        completion(nil,nil)
    }
    
    static var shared: RestaurantDataProvider = FakeDataProvider() as RestaurantDataProvider
    
    var config: URLSessionConfiguration!
    
    func getRestaurantsFor(searchTerm: String, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        
        processResponse(data: """
        {
        "businesses": [
                   {
                   "id": "lucy-ethiopian-kitchen-toronto",
                   "name": "Lucy Ethiopian Kitchen",
                   "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/krhvMTup3i8iuCUoJG0SRA/o.jpg",
                   "is_closed": false,
                   "url": "https://www.yelp.com/biz/lucy-ethiopian-kitchen-toronto?adjust_creative=UWdcppy-6Ydsll_BP_RAAQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=UWdcppy-6Ydsll_BP_RAAQ",
                   "review_count": 50,
                   "categories": [
                                  {
                                  "alias": "ethiopian",
                                  "title": "Ethiopian"
                                  }
                                  ],
                   "rating": 4.5,
                   "coordinates": {
                   "latitude": 43.6841128,
                   "longitude": -79.3207142
                   },
                   "transactions": [],
                   "price": "$$",
                   "location": {
                   "address1": "1690 Danforth Avenue",
                   "address2": "",
                   "address3": "",
                   "city": "Toronto",
                   "zip_code": "M4C",
                   "country": "CA",
                   "state": "ON",
                   "display_address": [
                                       "1690 Danforth Avenue",
                                       "Toronto, ON M4C",
                                       "Canada"
                                       ]
                   },
                   "phone": "+14164060534",
                   "display_phone": "+1 416-406-0534",
                   "distance": 6216.925481519999
                   },
                   {
                   "id": "ethiopian-house-restaurant-toronto",
                   "name": "Ethiopian House Restaurant",
                   "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/ECkvEB6_z0GDNtByTsG5ew/o.jpg",
                   "is_closed": false,
                   "url": "https://www.yelp.com/biz/ethiopian-house-restaurant-toronto?adjust_creative=UWdcppy-6Ydsll_BP_RAAQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=UWdcppy-6Ydsll_BP_RAAQ",
                   "review_count": 146,
                   "categories": [
                                  {
                                  "alias": "ethiopian",
                                  "title": "Ethiopian"
                                  }
                                  ],
                   "rating": 3.5,
                   "coordinates": {
                   "latitude": 43.66673,
                   "longitude": -79.3856
                   },
                   "transactions": [],
                   "price": "$$",
                   "location": {
                   "address1": "4 Irwin Avenue",
                   "address2": "",
                   "address3": "",
                   "city": "Toronto",
                   "zip_code": "M4Y 1K9",
                   "country": "CA",
                   "state": "ON",
                   "display_address": [
                                       "4 Irwin Avenue",
                                       "Toronto, ON M4Y 1K9",
                                       "Canada"
                                       ]
                   },
                   "phone": "+14169235438",
                   "display_phone": "+1 416-923-5438",
                   "distance": 1243.729655998
                   },
                   {
                   "id": "african-palace-toronto",
                   "name": "African Palace",
                   "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/NNbvetsz1RHsswHfPk6y6Q/o.jpg",
                   "is_closed": false,
                   "url": "https://www.yelp.com/biz/african-palace-toronto?adjust_creative=UWdcppy-6Ydsll_BP_RAAQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=UWdcppy-6Ydsll_BP_RAAQ",
                   "review_count": 77,
                   "categories": [
                                  {
                                  "alias": "ethiopian",
                                  "title": "Ethiopian"
                                  },
                                  {
                                  "alias": "african",
                                  "title": "African"
                                  }
                                  ],
                   "rating": 4,
                   "coordinates": {
                   "latitude": 43.66107,
                   "longitude": -79.42895
                   },
                   "transactions": [],
                   "price": "$$",
                   "location": {
                   "address1": "977 Bloor Street W",
                   "address2": "",
                   "address3": "",
                   "city": "Toronto",
                   "zip_code": "M6H 1L7",
                   "country": "CA",
                   "state": "ON",
                   "display_address": [
                                       "977 Bloor Street W",
                                       "Toronto, ON M6H 1L7",
                                       "Canada"
                                       ]
                   },
                   "phone": "+14165390259",
                   "display_phone": "+1 416-539-0259",
                   "distance": 2974.670903596
                   },
                ]
        }

        """.data(using: .utf8)!, completion: completion)
//        completion([
//            Restaurant.init(name: "Fake Ethiopian 1", price: 1, rating: 1, review: "It's OK"),
//            Restaurant.init(name: "Fake Ethiopian 2", price: 3, rating: 3, review: "This one is better"),
//            Restaurant.init(name: "Fake Ethiopian 3", price: 2, rating: 4, review: "This is the best")
//            ], nil)
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
    
    func processResponse(data: Data, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        completion(nil,nil)
    }
}
