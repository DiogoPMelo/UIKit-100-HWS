//
//  DetailView.swift
//  challenge-4
//
//  Created by Diogo Melo on 2/26/22.
//

import UIKit

class DetailView: UIViewController {
    var imageView: UIImageView!
    var data: ImageObj!
    
    override func loadView() {
        super.loadView()
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = data {
            title = data.name
            let path = getDocumentsDirectory().appendingPathComponent(data.image)
            imageView.image = UIImage(contentsOfFile: path.path)
            imageView.isAccessibilityElement = true
        }
            }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
