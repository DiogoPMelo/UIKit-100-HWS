//
//  JobCell.swift
//  challenge-5-CVAdapted
//
//  Created by Diogo Melo on 3/3/22.
//

import UIKit

class JobCell: UICollectionViewCell {
    
    var experience: Experience! {
        didSet {
            job.text = experience.name
            logo.accessibilityLabel = "Logo of \(experience.name)"
            if experience.startDate == experience.endDate {
                dates.text = "\(experience.startDate)"
            } else {
                dates.text = "\(experience.startDate)-\(experience.endDate - 2000)"
            }
        }
    }
    
    lazy var job: UILabel = {
        let label = UILabel()
        label.text = "job name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var dates: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.text = "2022"
        return label
    }()
    
    lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.isAccessibilityElement = true
        return imageView
    }()
    
    override func layoutSubviews() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        
        contentView.addSubview(job)
        job.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dates)
        dates.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.heightAnchor.constraint(equalTo: contentView.readableContentGuide.heightAnchor, multiplier: 0.5, constant: -5),
            logo.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            logo.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.centerXAnchor, constant: -5),
            
            dates.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.centerXAnchor, constant: 5),
            dates.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            dates.heightAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 0.8),
            dates.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            
            job.centerXAnchor.constraint(equalTo: contentView.readableContentGuide.centerXAnchor),
            job.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4, constant: -10),
            job.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor, constant: -10)
        ])
        
        [logo, job, dates].forEach {$0.isAccessibilityElement = false}
        contentView.isAccessibilityElement = true
        let datesLabel: String
        if let datesText = dates.text, datesText.contains("-") {
            let years = datesText.components(separatedBy: "-")
            datesLabel = "between \(years[0]) and \(years[1])"
        } else {
            datesLabel = "in \(dates.text!)"
        }
        contentView.accessibilityLabel = "\(job.text!), \(datesLabel)"
    }
    
    
}
