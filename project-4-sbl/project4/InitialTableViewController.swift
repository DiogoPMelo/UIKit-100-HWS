//
//  InitialTableViewController.swift
//  project4
//
//  Created by Diogo Melo on 2/13/22.
//

import UIKit

class InitialTableViewController: UITableViewController {
    var websites =   ["apple.com",   "hackingwithswift.com", "applevis.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Site")
        title = "Allowed sites"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webView = WebViewController()
        webView.websites = websites
        webView.initialIndex = indexPath.row
        navigationController?.pushViewController(webView, animated: true)
    }
}
