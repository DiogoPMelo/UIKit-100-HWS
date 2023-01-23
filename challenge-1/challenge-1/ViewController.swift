//
//  ViewController.swift
//  challenge-1
//
//  Created by Diogo Melo on 2/17/22.
//

import UIKit

class ViewController: UITableViewController {
var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("@3x.png") {
                countries.append(item)
            }
        }
        
        countries.sort()
        title = "FlagShare"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Country")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = CountryNameUtil.displayName(for: countries[indexPath.row])
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        
        detail.selectedImage = countries[indexPath.row]
        
        navigationController?.pushViewController(detail, animated: true)
    }
}

