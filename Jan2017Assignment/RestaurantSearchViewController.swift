//
//  RestaurantSearchViewController.swift
//  Jan2017Assignment
//
//  Created by Brendan Seabrook on 2018-01-13.
//  Copyright © 2018 Brendan Seabrook. All rights reserved.
//

import UIKit

class RestaurantSearchViewController: UIViewController, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var sortingPicker:UIPickerView!
    @IBOutlet weak var restaurantPreviews:UICollectionView!
    
    var restaurants:[Restaurant]?
    
    func formatData(toFormat:[Restaurant]?, method:(Restaurant, Restaurant) -> Bool, isReversed:Bool) -> [Restaurant]? {
        
        var toReturn:[Restaurant]? = toFormat?.sorted(by: method)
            
        if isReversed {
            toReturn = toReturn?.reversed()
        }

        return toReturn
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    public override func viewWillAppear(_ animated: Bool) {
        searchBar.text = "Ethiopian"
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    // MARK: - Searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text!.count > 0 {
            YelpDataProvider.shared.getRestaurantsFor(searchTerm: searchBar.text!, completion: { (restaurants, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: NSLocalizedString("Oh no.", comment: "Friendly exclamation that something went wrong"), message: error!.message(), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss error OK"), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DispatchQueue.main.sync {
                        let method = Restaurant.sortingMethods[self.sortingPicker.selectedRow(inComponent: 0)].method
                        let isReversed = self.sortingPicker.selectedRow(inComponent: 1) == 1
                        
                        self.restaurants = self.formatData(toFormat: restaurants, method: method, isReversed: isReversed)
                        self.restaurantPreviews.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - Sorting
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Restaurant.sortingMethods.count
        } else {
            return sortDirections.count
        }
    }
    
    private let sortDirections = ["Ascending", "Descending"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return Restaurant.sortingMethods[row].name
        } else {
            return sortDirections[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let method = Restaurant.sortingMethods[pickerView.selectedRow(inComponent: 0)].method
        let isReversed = pickerView.selectedRow(inComponent: 1) == 1
        
        restaurants = formatData(toFormat: restaurants, method: method, isReversed: isReversed)
        restaurantPreviews.reloadData()
    }
    
    // Mark: - Restaurant Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantPreview", for: indexPath) as! RestaurantPreview
        
        cell.populateWith(restaurant: restaurants![indexPath.row])
        
        return cell
    }
}

