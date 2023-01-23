//
//  DetailViewController.swift
//  UICollectionView-UITableView
//
//  Created by Diogo Melo on 2/24/22.
//  Copyright © 2022 Zafar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
var name = "Test"
    
    override func viewDidLoad() {
        super.viewDidLoad()

         let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
