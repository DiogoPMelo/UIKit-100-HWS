//
//  DetailView.swift
//  challenge-5-CVAdapted
//
//  Created by Diogo Melo on 3/3/22.
//

import UIKit

class DetailView: UIViewController {
    var experience: Experience!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = experience.name
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
