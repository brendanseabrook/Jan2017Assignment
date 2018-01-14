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
    var review_count:Int?
    var image_url:String!
    var image:UIImage?
    var reviews:[Review]?
    var addresses:[String]?
    var displayAddress:String? {
        if addresses == nil {
            return nil
        } else {
            return addresses?.joined(separator: ", ")
        }
    }
    
    var phone:String!
    var photos:[String]?
    var photoImages:[UIImage?]?
    var is_closed:Bool?
    var url:String?
    
    weak var displayedOnPreview:RestaurantPreview?
    weak var displayedOnInspect:RestaurantInspectViewController?
    
    init(record:[String:Any]) {
        self.populate(record: record)
    }
    
    func populate(record:[String:Any]) {
        self.id = record["id"] as? String
        self.name = record["name"] as? String
        self.price = record["price"] as? String ?? ""
        self.rating = record["rating"] as? Double
        self.review_count = record["review_count"] as? Int
        self.image_url = record["image_url"] as? String
        self.phone = record["display_phone"] as? String
        self.photos = record["photos"] as? [String]
        self.is_closed = record["is_closed"] as? Bool
        self.url = record["url"] as? String
        
        if let location = record["location"] as? [String:Any] {
            self.addresses = location["display_address"] as? [String]
        }
        
        //Immediately get more data for reviews
        DispatchQueue.global().async {
            YelpDataProvider.shared.getReviewsForRestaurant(id: self.id, completion: { (reviews, error) in
                //errors for fetching reviews should not be fatal.
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
        
        //Immediately get more data for background image
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
    
    func fetchPhotos() {
        DispatchQueue.main.sync {
            
            if self.photos != nil {
                self.photoImages = [UIImage]()
                for i in 0..<self.photos!.count {
                    self.photoImages!.append(UIImage())
                    DispatchQueue.global().async {
                        YelpDataProvider.shared.getData(stringURL: self.photos![i], queryComponents: [:], completion: { (data, error) in
                            //Log and ignore error. Non-fatal.
                            self.photoImages![i] = UIImage(data: data!)
                            self.displayedOnInspect?.refreshPhoto(ifAtIndex: i)
                        })
                    }
                }
            }
        }
    }
    
    func getInspectionData() {
        DispatchQueue.global().async {
        YelpDataProvider.shared.addDetailsToRestaurant(restaurant: self, completion: { (restaurant, error) in
                //errors when getting extra info should not be fatal.
                //TODO log error
                if error == nil {
                    self.fetchPhotos()
                }
            })
        }
    }
    
    func ratingAsStars() -> String? {
        if self.rating < 0 || self.rating > 5 {
            return nil
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
