//
//  ImageObj.swift
//  challenge-4
//
//  Created by Diogo Melo on 2/26/22.
//

import Foundation

class ImageObj: Codable {
    var name: String
    var image: String
    
    init (name: String, image: String) {
        self.name = name
        self.image = image
    }
}
