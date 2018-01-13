//
//  Restaurant.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import Foundation

class Restaurant {
    var name:String
    var price:Double
    var rating:Double
    var review:String
    
    init(name:String, price:Double, rating:Double, review:String) {
        self.name = name
        self.price = price
        self.rating = rating
        self.review = review
    }
    
    //MARK: - Sorting
    class SortingMethod {
        let name:String
        let method:(Restaurant, Restaurant) -> Bool
        
        init(name:String, method:@escaping (Restaurant,Restaurant) -> Bool) {
            self.name = name
            self.method = method
        }
    }
    
    static let sortingMethods = [
        SortingMethod(name: NSLocalizedString("Name", comment: "Label for sorting method"), method: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        }),
        SortingMethod(name: NSLocalizedString("Price", comment: "Label for sorting method"), method: { (lhs, rhs) -> Bool in
            return lhs.price < rhs.price
        }),
        SortingMethod(name: NSLocalizedString("Rating", comment: "Label for sorting method"), method: { (lhs, rhs) -> Bool in
            return lhs.rating < rhs.rating
        })
    ]
}
