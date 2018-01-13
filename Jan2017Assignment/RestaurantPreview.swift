//
//  RestaurantPreview.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import UIKit

class RestaurantPreview : UICollectionViewCell {
    static let reuse = "restaurantPreview"
    
    @IBOutlet weak var restaurantName:UILabel!
    @IBOutlet weak var restaurantPrice:UILabel!
    @IBOutlet weak var restaurantRating:UILabel!
    @IBOutlet weak var restaurantReview:UILabel!
    @IBOutlet weak var restaurantImage:UIImageView!
    
    weak var restaurant:Restaurant!
    
    func populateWith(restaurant:Restaurant) {
        self.restaurant = restaurant
        self.restaurantName.text = restaurant.name
        self.restaurantPrice.text = restaurant.price
        self.restaurantRating.text = restaurant.ratingAsStars()
        //TODO load review
        self.restaurantReview.text = ""
        self.restaurantImage.image = nil
        if restaurant.image != nil {
            self.restaurantImage.image = restaurant.image
        } else {
            self.restaurantImage.image = nil
        }
        
        if restaurant.reviews != nil && restaurant.reviews!.count > 0 {
            self.restaurantReview.text = restaurant.reviews![0].text
        } else {
            self.restaurantReview.text = ""
        }
        
        restaurant.displayedOnPreview = self
    }
    
    
    
}
