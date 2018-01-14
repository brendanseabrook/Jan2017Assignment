//
//  RestaurantInspectViewController.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import UIKit

class RestaurantInspectViewController : UIViewController {
    var restaurant:Restaurant? {
        willSet {
            newValue?.displayedOnInspect = self
            newValue?.getInspectionData()
        }
        didSet {
            oldValue?.displayedOnInspect = nil
        }
    }
    
    @IBOutlet weak var nav:UINavigationItem!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var rating:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var address:UILabel!
    @IBOutlet weak var phone:UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        layout()
    }
    
    func layout() {
        nav.title = restaurant?.name
        image.image = restaurant?.image
        
        priceLabel.isHidden = restaurant!.price.count < 1
        price.text = restaurant?.price
        rating.text = restaurant?.ratingAsStars()
        phone.text = restaurant?.phone
        
        if restaurant?.addresses != nil && restaurant!.addresses!.count > 0 {
            address.text = restaurant!.addresses!.joined(separator: ", ")
        }
    }
}
