//
//  ViewController.swift
//  project-1-sbl
//
//  Created by Diogo Melo on 2/13/22.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    var views = [String: Int]()
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 140, height: 180)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(loadImages), with: nil)
        title = "StormViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Picture")
    }

    @objc func loadImages () {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        let defaults = UserDefaults.standard
        if let saveData = defaults.object(forKey: "views") as? Data {
            if let views = try? JSONDecoder().decode([String: Int].self, from: saveData) {
                self.views = views
            }
        }
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                if views[item] == nil {
                views[item] = 0
                }
            }
        }
        
        pictures.sort(by: {$0 < $1})
        collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? Cell else {
            fatalError("Can't convert to custom cell")
        }
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.setImageLabel("Picture \(indexPath.item + 1) of \(pictures.count): \(pictures[indexPath.item])")
        cell.views = views[pictures[indexPath.item]] ?? 0
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailedViewController()
        vc.selectedImage = pictures[indexPath.item]
        vc.indexes = (image: indexPath.item + 1, total: pictures.count)
        views[pictures[indexPath.item]]? += 1
        collectionView.reloadData()
        performSelector(inBackground: #selector(save), with: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func save () {
        if let saveData = try? JSONEncoder().encode(views) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "views")
        }
    }

}

