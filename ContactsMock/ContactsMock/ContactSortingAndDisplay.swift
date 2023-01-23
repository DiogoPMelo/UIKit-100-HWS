//
//  ContactSortingAndDisplay.swift
//  ContactsMock
//
//  Created by Diogo Melo on 4/13/22.
//

import Foundation

enum ContactDisplaying: String, Equatable {
    case firstLast, lastFirst, lastCommaFirst, lastFirstInitial
    
    func displayContact (_ contact: Contact) -> String {
        let name: String
        if self == .firstLast {
            name = "\(contact.firstName) \(contact.lastName)"
        } else if self == .lastFirst {
            name = "\(contact.lastName) \(contact.firstName)"
        } else if self == .lastCommaFirst {
            name = "\(contact.lastName), \(contact.firstName)"
        } else {
            name = "\(contact.lastName), \(contact.firstName.first ?? " ")"
        }
        
        return "\(name)\n\(contact.number)"
    }
}

enum ContactSorting: String, Equatable {
    case first, last
    
    func initial(of contact: Contact) -> String {
        func initial(_ string: String) -> String {
            let standardized = string.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .none)
            return String(standardized.first ?? "?").uppercased()
        }
        
        if self == .first {
            return initial(contact.firstName)
        } else {
            return initial(contact.lastName)
        }
    }
    
    func sorter() -> ((Contact, Contact) -> Bool) {
        func isBefore(_ first: String, than second: String) -> Bool {
            return first.compare(second, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedAscending
        }
        
        func isEqual(_ first: String, and second: String) -> Bool {
            return first.compare(second, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedSame
        }
        
        let firstNameSorter: (Contact, Contact) -> Bool = { lhs, rhs in
            return isEqual(lhs.firstName, and: rhs.firstName) ?
            isBefore(lhs.lastName, than: rhs.lastName) :
            isBefore(lhs.firstName, than: rhs.firstName)
        }
        
        let lastNameSorter: (Contact, Contact) -> Bool = { lhs, rhs in
            return isEqual(lhs.lastName, and: rhs.lastName) ?
            isBefore(lhs.firstName, than: rhs.firstName) :
            isBefore(lhs.lastName, than: rhs.lastName)
        }
        
        if self == .first {
            return firstNameSorter
        } else {
            return lastNameSorter
        }
    }
}
