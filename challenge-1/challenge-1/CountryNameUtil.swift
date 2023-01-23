//
//  CountryNameUtil.swift
//  challenge-1
//
//  Created by Diogo Melo on 2/17/22.
//

import Foundation

struct CountryNameUtil {
    static func displayName (for filename: String) -> String {
        let parts = filename.components(separatedBy: "@")
        let name = parts[0]
        let caps: String
        if name.count <= 3 {
            caps = name.uppercased()
        } else {
            caps = name.prefix(1).capitalized + name.dropFirst()
        }
        return caps
    }
}
