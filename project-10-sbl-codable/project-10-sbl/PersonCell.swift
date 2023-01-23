//
//  PersonCell.swift
//  project-10-sbl
//
//  Created by Diogo Melo on 2/24/22.
//

import UIKit

class PersonCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        return UIImageView(frame: CGRect(x: 10, y: 10, width: 120, height: 120))
    }()
    
    lazy var name: UILabel = {
        let name = UILabel(frame: CGRect(x: 10, y: 134, width: 120, height: 40))
        let font = UIFont.systemFont(ofSize: 16, weight: .thin)
        name.font = font
        name.text = "label"
        name.textAlignment = .center
        name.textColor = .black
        name.numberOfLines = 2
        return name
    }()
    
    override func layoutSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(name)
    }

}
