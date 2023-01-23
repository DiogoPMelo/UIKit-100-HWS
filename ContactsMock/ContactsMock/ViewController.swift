//
//  ViewController.swift
//  ContactsMock
//
//  Created by Diogo Melo on 4/13/22.
//

import UIKit

class ViewController: UITableViewController {
var contactList = ContactList()
    
    var needsReloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contactList.count == 0 {
        contactList.addContact(Contact(name: "Camilo Ferreira"),
                 Contact(name: "João Barbosa"), Contact(name: "Ricardo Bré"), Contact(name: "Catarina Gomes"), Contact(name: "Catarina Cunha"),
                 Contact(name: "Inês Melo"), Contact(name: "Inês Ataíde"), Contact(name: "Inês Sousa"), Contact(name: "Débora Silva"),
                 Contact(name: "Diogo Melo"), Contact(name: "Amadeu Melo"), Contact(name: "Ivete Pinto"), Contact(name: "Andreia Alves"), Contact(name: "Carmen Castro"), Contact(name: "Sofia Rodrigues"), Contact(name: "Beatriz Ferreira"), Contact(name: "Daniel Morgado"))
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeSort))
        navigationItem.backButtonTitle = "Home"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if needsReloading {
        tableView.reloadData()
            needsReloading = false
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        contactList.initials.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < contactList.initials.count {
        return contactList.initials[section]
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < contactList.initials.count {
        return contactList.contactsStartingWith(initialAt: section).count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section < contactList.initials.count {
        let contact = getContact(at: indexPath)
            cell.textLabel?.text = contactList.displayMode.displayContact(contact)
            cell.textLabel?.numberOfLines = 2
        } else {
            cell.textLabel?.text = "\(contactList.count) contacts"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = getContact(at: indexPath)
        let ac = UIAlertController(title: contactList.displayMode.displayContact(contact), message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = contact.firstName
        ac.textFields?[0].autocapitalizationType = .words
        ac.addTextField()
        ac.textFields?[1].text = contact.lastName
        ac.textFields?[1].autocapitalizationType = .words
        ac.addTextField()
        ac.textFields?[2].text = contact.number
        ac.textFields?[2].keyboardType = .phonePad
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let submitAction = UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            guard let firstName = ac?.textFields?[0].text,
                  let lastName = ac?.textFields?[1].text,
                  let number = ac?.textFields?[2].text
            else {return}
            let updatedContact = Contact(firstName: firstName, lastName: lastName, number: number)
            self?.contactList.editContact(contact, to: updatedContact)
            self?.tableView.reloadData()
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "delete", style: .destructive) { [weak self, weak ac] _ in
            let deleteAC = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete \(self?.contactList.displayMode.displayContact(contact).components(separatedBy: "\n")[0] ?? "this contact")?", preferredStyle: .alert)
            deleteAC.addAction(UIAlertAction(title: "No", style: .cancel))
            deleteAC.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak ac] _ in
                self?.contactList.deleteContact(contact)
                self?.tableView.reloadData()
            })
            self?.present(deleteAC, animated: true)
        })
        present(ac, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func getContact(at indexPath: IndexPath) -> Contact {
        contactList.contactsStartingWith(initialAt: indexPath.section)[indexPath.row]
    }
    
    @objc func addContact () {
        let ac = UIAlertController(title: "Add contact", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].autocapitalizationType = .words
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Create", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else {return}
            var name = text
            if name.isEmpty {
                name = "Unnamed Contact"
            } else if name.components(separatedBy: " ").count < 2 {
                name += " Coisinho"
            }
            
            self?.contactList.addContact(Contact(name: name))
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    @objc func changeSort () {
let ovc = OptionsViewController()
        ovc.delegate = self
        navigationController?.pushViewController(ovc, animated: true)
    }


}

