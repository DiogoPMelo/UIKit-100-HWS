//
//  ViewController.swift
//  project-38-sbl
//
//  Created by Diogo Melo on 5/3/22.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Commit")
    }


}

