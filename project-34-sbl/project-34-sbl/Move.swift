//
//  Move.swift
//  project-34-sbl
//
//  Created by Diogo Melo on 4/20/22.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int

    init(column: Int) {
        self.column = column
    }
}
