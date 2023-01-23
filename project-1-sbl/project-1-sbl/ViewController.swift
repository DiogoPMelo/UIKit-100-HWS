//
//  ViewController.swift
//  project-1-sbl
//
//  Created by Diogo Melo on 2/13/22.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(loadImages), with: nil)
        title = "StormViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "Picture")
    }

    @objc func loadImages () {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort(by: {$0 < $1})
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1): \(pictures[indexPath.row]))"
        cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedViewController()
        vc.selectedImage = pictures[indexPath.row]
        vc.indexes = (image: indexPath.row + 1, total: pictures.count)
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

