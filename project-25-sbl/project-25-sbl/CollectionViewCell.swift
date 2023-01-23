//
//  CollectionViewCell.swift
//  project-25-sbl
//
//  Created by Diogo Melo on 3/18/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.isAccessibilityElement = true
        image.accessibilityLabel = "Picture"
        return image
    }()
    
    override func layoutSubviews() {
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setLabel(_ index: Int) {
        image.accessibilityLabel = "Picture \(index + 1)"
    }
}
