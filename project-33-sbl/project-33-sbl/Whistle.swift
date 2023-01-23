//
//  Whistle.swift
//  project-33-sbl
//
//  Created by Diogo Melo on 4/10/22.
//

import UIKit
import CloudKit

class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
