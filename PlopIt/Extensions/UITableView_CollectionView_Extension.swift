//
//  UITableView_CollectionView_Extension.swift
//  Crispin_Orthotics
//
//  Created by Raivis Olehno on 15/12/2021.
//

import UIKit

extension UITableView {
    
    public func registerNibArray(withNames names: [String]) {
        for name in names {
            let nib = UINib(nibName: name, bundle: nil)
            self.register(nib, forCellReuseIdentifier: name)
        }
    }
    
}

extension UICollectionView {
    
    public func registerNibArray(withNames names: [String]) {
        for name in names {
            let nib = UINib(nibName: name, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: name)
        }
    }
    
}
