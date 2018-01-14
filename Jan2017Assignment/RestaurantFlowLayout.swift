//
//  RestaurantFlowLayout.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//
// This class is used to layout a collection view of restaurants
// It is currently coded to provide a 2 by 5 grid as that seems to
// be best for the requirement of 10 on screen while still fitting
// all the info in. A better so

import UIKit

class RestaurantFlowLayout : UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: collectionView!.frame.width/2, height: collectionView!.frame.height/5)
        }
        set {
            self.itemSize = CGSize(width: collectionView!.frame.width/2, height: collectionView!.frame.height/5)
        }
    }
}
