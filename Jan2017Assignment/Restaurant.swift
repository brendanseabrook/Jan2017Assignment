//
//  Restaurant.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import UIKit

class Restaurant {
    var id:String!
    var name:String!
    var price:String!
    var rating:Double!
    var image_url:String!
    var image:UIImage?
    var reviews:[Review]?
    weak var displayedOnPreview:RestaurantPreview?
    
    init?(record:[String:Any]) {
        self.id = record["id"] as? String
        self.name = record["name"] as? String
        self.price = record["price"] as? String ?? ""
        self.rating = record["rating"] as? Double
        self.image_url = record["image_url"] as? String
        
        //The following fields should be requred to be considered valid data. Records that don't have these fields should just be ignored
        guard self.id != nil else {
            return nil
        }
        
        DispatchQueue.global().async {
            YelpDataProvider.shared.getReviewsForRestaurant(id: self.id, completion: { (reviews, error) in
                //errors for fetching reviews should be fatal.
                //TODO log error
                if error == nil {
                    self.reviews = reviews
                    if self.displayedOnPreview != nil {
                        DispatchQueue.main.async {
                            self.displayedOnPreview?.restaurantReview.text = self.reviews![0].text
                        }
                    }
                }
            })
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: self.image_url!) else {
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            self.image = image
            if self.displayedOnPreview != nil {
                DispatchQueue.main.async {
                    self.displayedOnPreview?.restaurantImage.image = self.image
                }
            }
        }
    }
    
    func ratingAsStars() -> String {
        if self.rating < 0 || self.rating > 5 {
            return "None"
        } else {
            var toReturn = ""
            for i in stride(from: self.rating, to: 0, by: -1) {
                if i == 0.5 {
                    toReturn += "½"
                } else {
                    toReturn += "★"
                }
            }
            return toReturn
        }
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
            return lhs.price.count < rhs.price.count //Price is based on number of '$' characters in string
        }),
        SortingMethod(name: NSLocalizedString("Rating", comment: "Label for sorting method"), method: { (lhs, rhs) -> Bool in
            return lhs.rating < rhs.rating
        })
    ]
}

class Review {
    var text:String?
    
    init(record:[String:Any]) {
        text = record["text"] as? String
    }
}
