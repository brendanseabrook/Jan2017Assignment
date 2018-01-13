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
    
    func populateWith(restaurant:Restaurant) {
        self.restaurantName.text = restaurant.name
        self.restaurantPrice.text = String(restaurant.price)
        self.restaurantRating.text = String(restaurant.rating)
        //TODO load review
        self.restaurantReview.text = "TODO, load review"
    }
    
}
