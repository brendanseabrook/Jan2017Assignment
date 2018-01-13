//
//  RestaurantInspectViewController.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import UIKit

class RestaurantInspectViewController : UIViewController {
    var restaurant:Restaurant?
    
    @IBOutlet weak var nav:UINavigationItem!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var rating:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        nav.title = restaurant?.name
        image.image = restaurant?.image
        
        priceLabel.isHidden = restaurant!.price.count < 1
        price.text = restaurant?.price
        rating.text = restaurant?.ratingAsStars()
    }
}
