//
//  TabBarController.swift
//  UICollectionView-UITableView
//
//  Created by Zafar on 1/27/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .black
        
        let tableVC = UINavigationController(rootViewController: TableViewController())
        tableVC.tabBarItem = UITabBarItem(title: "Table", image: nil, selectedImage: nil)
        
        let collectionVC = UINavigationController(rootViewController: CollectionViewController())
        collectionVC.tabBarItem = UITabBarItem(title: "Collection", image: nil, selectedImage: nil)
        
        self.viewControllers = [tableVC, collectionVC]
    }
    
}
