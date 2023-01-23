//
//  ViewController.swift
//  project-7-sbl
//
//  Created by Diogo Melo on 2/20/22.
//

import UIKit

class ViewController: UITableViewController {
var petitions = [Petition]()
    var allPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
        @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func showFilter () {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let resetAction = UIAlertAction(title: "Reset", style: .cancel) { [weak self] _ in
            if let allPetitions = self?.allPetitions {
                self?.petitions = allPetitions
                self?.tableView.reloadData()
            }
        }
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text, let petitions = self?.allPetitions else {return}
            
            DispatchQueue.global(qos: .userInteractive).async {
            self?.petitions = petitions.filter({$0.title.contains(text) || $0.body.contains(text)})
                self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }
        }
        
        ac.addAction(resetAction)
        ac.addAction(filterAction)
        
        present(ac, animated: true)
    }
    
    @objc func showCredits () {
        let ac = UIAlertController(title: "Credits", message: "This lunacy and sometimes chalupicy comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            petitions = allPetitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.accessoryType = .disclosureIndicator
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
