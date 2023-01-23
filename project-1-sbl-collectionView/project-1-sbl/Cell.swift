//
//  Cell.swift
//  project-1-sbl-col
//
//  Created by Diogo Melo on 2/25/22.
//

import UIKit

class Cell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
//        imageView.isAccessibilityElement = true
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 134, width: 120, height: 20))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 154, width: 120, height: 20))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.text = "0 views"
        return label
    }()
    
    var views = 0 {
        didSet {
            viewsLabel.text = "\(views) views"
        }
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(viewsLabel)
    }
    
    func setImageLabel (_ label: String) {
//        imageView.accessibilityLabel = label
        self.label.text = label
    }
}
