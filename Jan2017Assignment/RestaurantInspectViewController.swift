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
    @IBOutlet weak var restaurantName:UITextView!
    @IBOutlet weak var url:UITextView!
    @IBOutlet weak var phone:UITextView!
    @IBOutlet weak var address:UITextView!
    @IBOutlet weak var price:UITextView!
    @IBOutlet weak var rating:UITextView!
    @IBOutlet weak var images:UIImageView!
    @IBOutlet weak var reviews:UITextView!
    
    override func viewDidLoad() {
        layout()
    }
    
    func layout() {

        //TODO would do some size fitting with the text
        self.restaurantName.text = restaurant?.name
        
        if restaurant?.url == nil {
            self.url.text = NSLocalizedString("No Website", comment: "Text describing the restaurant has no website")
        } else {
            self.url.text = NSLocalizedString("Website", comment: "Link word for restaurants website")
            self.url.textColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        }
        
        
    }
}
