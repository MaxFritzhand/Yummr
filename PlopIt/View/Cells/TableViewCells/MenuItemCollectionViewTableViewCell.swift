//
//  MenuItemCollectionViewTableViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 06/03/2022.
//

import UIKit

class MenuItemCollectionViewTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryItems: [String] = []
    var tapHandler: ((Int) -> ())!
    var selectedCategory = 0
    var didScrollToSecondIndex = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCollectionView(withMenuCategoryItems items: [String], selectedCategory: Int,  tapHandler: @escaping (Int) -> ()) {
        self.selectedCategory = selectedCategory
        self.tapHandler = tapHandler
        self.categoryItems = items
        self.collectionView.registerNibArray(withNames: ["MenuCategoryItemCollectionViewCell"])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        //self.collectionView?.scrollToItem(at:IndexPath(item: selectedCategory, section: 0), at: .left, animated: true)
    }
}

extension MenuItemCollectionViewTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapHandler(indexPath.item)
        
    }
}

extension MenuItemCollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCategoryItemCollectionViewCell", for: indexPath) as? MenuCategoryItemCollectionViewCell else {
                fatalError()
            }
            
            cell.update(withCategoryItem: "All", selected: indexPath.item == selectedCategory)
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCategoryItemCollectionViewCell", for: indexPath) as? MenuCategoryItemCollectionViewCell else {
                fatalError()
            }
            
            cell.update(withCategoryItem: categoryItems[indexPath.item - 1], selected: indexPath.item == selectedCategory)
            return cell
        }
    }
}
