//
//  ViewController.swift
//  challenge-6-notes
//
//  Created by Diogo Melo on 3/7/22.
//

import UIKit

class ViewController: UITableViewController {

    var notes = ["note1", "note2", "note3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Note")
        notes.shuffle()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.note = notes[indexPath.row]
        detail.index = indexPath.row
        detail.owner = self
        navigationController?.pushViewController(detail, animated: true)
            }
    
    func save () {
        tableView.reloadData()
    }
    
}

