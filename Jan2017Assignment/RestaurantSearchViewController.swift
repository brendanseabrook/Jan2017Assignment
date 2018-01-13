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
    
    var toDisplay:[Restaurant]?

    public override func viewWillAppear(_ animated: Bool) {
        searchBar.text = "Ethiopian"
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    // MARK: - Searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text!.count > 0 {
            FakeDataProvider.shared.getRestaurantsFor(searchTerm: searchBar.text!, completion: { (restaurants, error) in
                toDisplay = restaurants
                restaurantPreviews.reloadData()
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

