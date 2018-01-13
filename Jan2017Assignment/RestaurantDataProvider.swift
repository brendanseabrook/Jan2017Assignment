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
    case BadResponse
    case BadAPIKey
    
    func message() -> String {
        switch self {
        case .BadAPIKey:
            return NSLocalizedString("Application may be out of date. Please check for app updates", comment: "Error message describing that the app might be out of date")
        case .BadRequest:
            return NSLocalizedString("Something went wrong with the app. Please try again later or check for updates", comment: "Error message describing that the client (app) failed and the solution may be to retry later or update app")
        case .BadResponse:
            return NSLocalizedString("Something went wrong with the server. Please try again later or check for updates", comment: "Error message describing that the server failed and the solution may be to retry later or update app")
        }
    }
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
            
            if data == nil || error != nil || (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, .BadRequest)
                return
            }
            
            self.processResponse(data: data!, completion: completion)
        })
        
        dataTask.resume()
    }
    
    internal func processResponse(data: Data, completion: @escaping ([Restaurant]?, RestaurantDataProviderError?) -> Void) {
        
        guard let results = (try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))) as? Dictionary<String,Any> else {
            completion(nil, .BadResponse)
            return
        }
        
        if let error = results["error"] as? [String:Any] {
            if let errorCode = error["code"] as? String {
                if errorCode == "TOKEN_INVALID" {
                    completion(nil, .BadAPIKey)
                    return
                } else if errorCode == "VALIDATION_ERROR" {
                    completion(nil, .BadRequest)
                    return
                } else { //TODO consider more granular response
                    completion(nil, .BadResponse)
                    return
                }
            } else { //TODO consider more granular response
                completion(nil, .BadResponse)
                return
            }
        }
        
        guard let businesses = results["businesses"] as? [[String:Any]] else {
            completion(nil, .BadResponse)
            return
        }
        
        //TODO map down to optional
        completion(businesses.map({ (business) -> Restaurant in
            return Restaurant(record: business)!
        }), nil)
    }
}
