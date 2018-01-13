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

    public override func viewWillAppear(_ animated: Bool) {
        searchBar.text = "Ethiopian"
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    // MARK: - Searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search for \(String(describing: searchBar.text))")
    }
    
    // MARK: - Sorting
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortMethods.count
    }
    
    private let sortMethods = ["Name", "Price"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortMethods[row]
    }
    
    // Mark: - Restaurant Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantPreview", for: indexPath)
    }
    
}

