//
//  ViewController.swift
//  project-19-sbl
//
//  Created by Diogo Melo on 3/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let label = UILabel()
                                label.text = "Just focus on Extension"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

