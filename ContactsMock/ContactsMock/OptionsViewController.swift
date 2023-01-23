//
//  OptionsViewController.swift
//  ContactsMock
//
//  Created by Diogo Melo on 4/13/22.
//

import UIKit

class OptionsViewController: UITableViewController {
    weak var delegate: ViewController!
let display = ["First Last", "Last First", "Last, First", "Last, First Initial"]
    let displayOptions: [ContactDisplaying] = [.firstLast, .lastFirst, .lastCommaFirst, .lastFirstInitial]
    let sorters = ["First", "Last"]
    let sorterOptions: [ContactSorting] = [.first, .last]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Option")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        optionsBySection(section).title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        optionsBySection(section).options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath)
        
        cell.textLabel?.text = optionsBySection(indexPath.section).options[indexPath.row]
        if indexPath.section == 0 {
            if sorterOptions[indexPath.row] == delegate.contactList.sortingCriteria {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            if displayOptions[indexPath.row] == delegate.contactList.displayMode {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                let newSorter = sorterOptions[indexPath.row]
                if delegate.contactList.sortingCriteria != newSorter {
                    delegate.contactList.setContactSorting(newSorter)
                    delegate.needsReloading = true
                }
            } else {
                let newDisplayOption = displayOptions[indexPath.row]
                if delegate.contactList.displayMode != newDisplayOption {
                delegate.contactList.setDisplayMode(newDisplayOption)
                    delegate.needsReloading = true
                }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func optionsBySection(_ section: Int) -> (title: String, options: [String]) {
        if section == 0 {
            return ("Sort By", sorters)
        } else {
            return ("Display", display)
        }
    }
    
}
