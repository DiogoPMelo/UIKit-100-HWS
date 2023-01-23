//
//  Experience.swift
//  challenge-5-CVAdapted
//
//  Created by Diogo Melo on 3/3/22.
//

import Foundation

struct Experience: Codable {
    var name: String
    var startDate: Int
    var endDate: Int
    var type: ExperienceTypes
    var role: String
    var description: String
    var responsibilities: String
    var technologies: String
    var comments: String
}

enum ExperienceTypes: String, Codable {
    case job, degree, project
}
