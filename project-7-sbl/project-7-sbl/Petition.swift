//
//  Petition.swift
//  project-7-sbl
//
//  Created by Diogo Melo on 2/20/22.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
