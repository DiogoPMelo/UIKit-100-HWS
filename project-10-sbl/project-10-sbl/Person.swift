//
//  Person.swift
//  project-10-sbl
//
//  Created by Diogo Melo on 2/25/22.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
