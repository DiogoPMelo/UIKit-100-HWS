//
//  ViewController.swift
//  project-32-sbl
//
//  Created by Diogo Melo on 4/8/22.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class ViewController: UITableViewController, SFSafariViewControllerDelegate {
var projects = [[String]]()
    var favorites = Set([Int]())
    var lastPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
        
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "Favorites") as? [Int] {
            favorites = Set(savedFavorites)
        }
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let project = projects[indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title: project[0], subtitle: project[1])
        cell.textLabel?.numberOfLines = 0
        
        if favorites.contains(indexPath.row) {
            cell.editingAccessoryType = .checkmark
            cell.accessibilityLabel = "Favorite \(cell.textLabel?.text ?? project[0])"
        } else {
            cell.editingAccessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            favorites.insert(indexPath.row)
            index(item: indexPath.row)
        } else {
            if favorites.contains(indexPath.row) {
                favorites.remove(indexPath.row)
                deindex(item: indexPath.row)
            }
        }
        
        let defaults = UserDefaults.standard
        defaults.set(Array(favorites), forKey: "Favorites")
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func index(item: Int) {
        let project = projects[item]

        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = project[0]
        attributeSet.contentDescription = project[1]

        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }

    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if favorites.contains(indexPath.row) {
            return .delete
        } else {
            return .insert
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        let backButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(showLastPage))
        backButton.accessibilityLabel = "Back to project \(lastPage + 1)"
        navigationItem.rightBarButtonItem = backButton
    }

    func showTutorial(_ which: Int) {
        guard     let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") else { return}
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        lastPage = which
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func showLastPage () {
        showTutorial(lastPage)
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
                                                                                 let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
                                                                                 
                                                                                 let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
                                                                                 let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)

                                                                                 titleString.append(subtitleString)

                                                                                 return titleString
    }

}

