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
    var toDisplay:[Restaurant]? {
        set {
            DispatchQueue.main.sync {
                if newValue != nil {
                    restaurants = formatData(toFormat: newValue!)
                } else {
                    restaurants = nil
                }
                restaurantPreviews.reloadData()
            }
        }
        get {
            return restaurants
        }
    }
    
    func formatData(toFormat:[Restaurant]?) -> [Restaurant]? {
        
        if toFormat == nil {
            return nil
        }
        
        var toReturn = toFormat!.sorted(by: Restaurant.sortingMethods[sortingPicker.selectedRow(inComponent: 0)].method)
        
        if sortingPicker.selectedRow(inComponent: 1) == 1 {
            toReturn = toReturn.reversed()
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
                    self.toDisplay = restaurants
                    DispatchQueue.main.sync {
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
        restaurants = formatData(toFormat: toDisplay)
        restaurantPreviews.reloadData()
    }
    
    // Mark: - Restaurant Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDisplay?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantPreview", for: indexPath) as! RestaurantPreview
        
        if indexPath.row % 3 == 0 {
            cell.backgroundColor = UIColor.red
        } else if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.blue
        }
        
        cell.populateWith(restaurant: toDisplay![indexPath.row])
        
        return cell
    }
}

