//
//  DetailViewController.swift
//  challenge-1
//
//  Created by Diogo Melo on 2/17/22.
//

import UIKit

class DetailViewController: UIViewController {
    var imageView: UIImageView!
    var selectedImage: String?
    
    override func loadView() {
        super.loadView()

        imageView = UIImageView()
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = selectedImage {
            imageView.image = UIImage(named: image)
            let country = CountryNameUtil.displayName(for: image)
            title = country
            imageView.accessibilityLabel = "Flag of \(country)"
            imageView.isAccessibilityElement = true
        }
        
        navigationItem.largeTitleDisplayMode = .never
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
    }
    
    @objc func shareFlag () {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("no image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
