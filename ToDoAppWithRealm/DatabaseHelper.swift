//
//  DatabaseHelper.swift
//  ToDoAppWithRealm
//
//  Created by Sabbir Hossain on 13/1/23.
//

import UIKit
import RealmSwift

class DatabaseHelper {
    static let shared = DatabaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabaseURL()->URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveContact(contact: Contact) {
        try! realm.write({
            realm.add(contact)
        })
    }
    
    
    
    func getAllContacts()->[Contact] {
        return Array(realm.objects(Contact.self))
    }
    
    func deleteContact(contact: Contact) {
        try! realm.write({
            realm.delete(contact)
        })
    }
    
    func updateContact(oldContact: Contact, newContact: Contact) {
        try! realm.write({
            oldContact.firstName = newContact.firstName
            oldContact.lastName = newContact.lastName
            oldContact.phoneNumber = newContact.phoneNumber
        })
    }
    
}
