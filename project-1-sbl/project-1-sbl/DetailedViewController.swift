//
//  DetailedViewController.swift
//  project-1-sbl
//
//  Created by Diogo Melo on 2/13/22.
//

import UIKit

class DetailedViewController: UIViewController {
    var imageView: UIImageView!
    var selectedImage: String?
    var indexes: (image: Int, total: Int)?
    
    override func loadView() {
        super.loadView()
        imageView = UIImageView()
//        imageView.window?.rootViewController = self
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
        if let indexes = indexes {
            title = "Image \(indexes.image) of \(indexes.total)"
        } else {
            title = selectedImage
        }
        
        navigationItem.largeTitleDisplayMode = .never
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = selectedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    
}
