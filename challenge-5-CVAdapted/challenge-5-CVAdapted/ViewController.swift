//
//  ViewController.swift
//  challenge-5-CVAdapted
//
//  Created by Diogo Melo on 3/3/22.
//

import UIKit

class ViewController: UICollectionViewController {
var experiences = [Experience]()
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = UIScreen.main.bounds.width * 0.45
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(JobCell.self, forCellWithReuseIdentifier: "Job")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        
        performSelector(inBackground: #selector(loadData), with: nil)
    }

    @objc func loadData () {
        guard let jobURL = Bundle.main.url(forResource: "job_data", withExtension: "json") else {
            fatalError("No data")
        }
            if let data = try? Data(contentsOf: jobURL) {
let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let experiences = try? decoder.decode([Experience].self, from: data) {
                    self.experiences = experiences
                    DispatchQueue.main.async {
                        self.experiences = experiences
                        self.collectionView.reloadData()
                    }
                }
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return experiences.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Job", for: indexPath) as? JobCell else {
            fatalError("Couldn't dequeue JobCell")
        }
        cell.experience = experiences[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = DetailView()
        detail.experience = experiences[indexPath.item]
        navigationController?.pushViewController(detail, animated: true)
    }
    
    override func accessibilityPerformEscape() -> Bool {
        UIAccessibility.post(notification: .announcement, argument: "nothing to dismiss")
        return true
    }
}

