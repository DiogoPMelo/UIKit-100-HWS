//
//  ViewController.swift
//  challenge-2
//
//  Created by Diogo Melo on 2/20/22.
//

import UIKit

class ViewController: UITableViewController {
var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Item")
        updateTitle()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItem))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(resetList))
    }

    @objc func resetList () {
        items.removeAll(keepingCapacity: true)
        tableView.reloadData()
        updateTitle()
    }
    
    @objc func newItem () {
        let ac = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else {
                return
            }
            self?.addItem(item)
        }
        ac.addAction(addAction)
        present(ac, animated: true)
    }
    
    func addItem(_ item: String) {
        let end = items.count
        items.insert(item, at: end)
        
        tableView.insertRows(at: [IndexPath.init(row: end, section: 0)], with: .automatic)
        updateTitle()
    }
    
    func updateTitle () {
        title = "ShoppingList(\(items.count))"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

}

