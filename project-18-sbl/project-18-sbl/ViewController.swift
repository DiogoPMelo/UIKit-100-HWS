//
//  ViewController.swift
//  project-18-sbl
//
//  Created by Diogo Melo on 3/3/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let ar = [1, 2, 3]
        assert(ar.count == 3, "Smaller array")
//        print("Element \(ar[3])")
        for i in 1 ... 100 {
            print("Got number", "\(i)", separator: "=", terminator: "\n\n")
        }
        
    }


}

