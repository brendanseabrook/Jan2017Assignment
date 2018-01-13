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
    
    override func viewWillAppear(_ animated: Bool) {
        nav.title = restaurant?.name
    }
}
