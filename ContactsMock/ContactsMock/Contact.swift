//
//  Contact.swift
//  ContactsMock
//
//  Created by Diogo Melo on 4/13/22.
//

import Foundation

struct ContactList {
    private var contacts: [String: [Contact]]
    private(set) var initials: [String]
    var count: Int {
        contacts.values.reduce(0) {$0 + $1.count}
    }
    private(set) var sortingCriteria: ContactSorting
    private(set) var displayMode: ContactDisplaying
    private var allContacts: [Contact] {
        contacts.values.reduce([Contact]()) {$0 + $1}.sorted(by: sortingCriteria.sorter())
    }
    
    init () {
        contacts = [String: [Contact]]()
        initials = [String]()
        
        let defaults = UserDefaults.standard
        
        if let savedSorting = defaults.string(forKey: "sort") {
            sortingCriteria = ContactSorting(rawValue: savedSorting) ?? .first
        } else {
        sortingCriteria = .first
        }
        
        if let savedDisplay = defaults.string(forKey: "display") {
            displayMode = ContactDisplaying(rawValue: savedDisplay) ?? .firstLast
        } else {
        displayMode = .firstLast
        }
        
        if let savedContacts = defaults.data(forKey: "contacts") {
            if let allContacts = try? JSONDecoder().decode([Contact].self, from: savedContacts) {
                processContacts(fromList: allContacts)
            }
        }
    }
    
    mutating func deleteContact (_ contact: Contact) {
        let initial = sortingCriteria.initial(of: contact)
        var letterContacts = contactsStartingWith(initial)
        if let index = letterContacts.firstIndex(of: contact) {
            letterContacts.remove(at: index)
            if letterContacts.isEmpty {
                contacts.removeValue(forKey: initial)
                recalculateInitials()
            } else {
            contacts[initial, default: []] = letterContacts
            }
        }
        saveContacts()
    }
    
    func contactsStartingWith(initialAt index: Int) -> [Contact] {
        contactsStartingWith(initials[index])
    }
    
    func contactsStartingWith(_ letter: String) -> [Contact] {
        contacts[letter, default: []]
    }
    
    mutating func addContact(_ contacts: Contact...) {
        for contact in contacts {
            self.indexContact(contact)
        }

        recalculateInitials()
        saveContacts()
    }
    
    mutating func editContact (_ initial: Contact, to updated: Contact) {
        guard initial != updated else {return}
        var allContacts = self.allContacts
        if let oldIndex = allContacts.firstIndex(of: initial) {
            allContacts.remove(at: oldIndex)
        }
        allContacts.append(updated)
        processContacts(fromList: allContacts)
        saveContacts()
    }
    
    private mutating func indexContact (_ contact: Contact) {
        let initial = sortingCriteria.initial(of: contact)
        contacts[initial, default: [Contact]()].append(contact)
        contacts[initial]?.sort(by: sortingCriteria.sorter())
    }
    
    mutating func setContactSorting(_ newMode: ContactSorting) {
        guard newMode != self.sortingCriteria else { return }
        
        sortingCriteria = newMode
        let defaults = UserDefaults.standard
        defaults.set(sortingCriteria.rawValue, forKey: "sort")
        
        let allContacts = self.allContacts
        processContacts(fromList: allContacts)
    }
    
    private mutating func processContacts(fromList allContacts: [Contact]) {
        contacts.removeAll()
        for contact in allContacts {
            indexContact(contact)
        }
        
        recalculateInitials()
    }
    
    mutating func setDisplayMode(_ newMode: ContactDisplaying) {
        
        guard newMode != displayMode else {return}
        
        displayMode = newMode
        
        let defaults = UserDefaults.standard
        defaults.set(displayMode.rawValue, forKey: "display")
    }
    
    private mutating func recalculateInitials () {
        self.initials = Array(contacts.keys).sorted()
    }
    
    private func saveContacts () {
        let defaults = UserDefaults.standard
        if let json = try? JSONEncoder().encode(allContacts) {
        defaults.set(json, forKey: "contacts")
        }
    }
     
}

struct Contact: Codable, Hashable, Equatable {
    var firstName: String
    var lastName: String
    var number: String
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.number == rhs.number
    }
}

extension Contact {
    init (name: String) {
        let components = name.components(separatedBy: " ")
        firstName = components[0]
        lastName = components[1]
        number = "9\([1, 3, 6].randomElement()!)"
        for _ in 1...7 {
            number += String(Int.random(in: 0...9))
        }
    }
}
