//
//  Model.swift
//  ToDoAppWithRealm
//
//  Created by Sabbir Hossain on 13/1/23.
//

import UIKit
import Foundation
import RealmSwift

class Contact: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var phoneNumber: String
    
    convenience init(id: Int,firstName: String,lastName: String, phoneNumber: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
    
    @discardableResult
    static func add(contact: Contact) -> Contact? {
        
        var returnValue: Contact?
        // Writing to Realm is added to auto release pool to avoid memory issues
        autoreleasepool {
            let realm: Realm = try! Realm()
            do {
                try realm.write {
                    realm.add(contact, update: .modified)
                }
                returnValue = contact
            }catch {
                // Error adding data
                returnValue = nil
            }
        }
        return returnValue
    }
    
    @discardableResult
    static func update(contact: Contact,firstName: String, lastName: String , phoneNumber: String) -> Contact? {
        
        var returnValue: Contact?
        // Writing to Realm is added to auto release pool to avoid memory issues
        autoreleasepool {
            let realm: Realm = try! Realm()
            do {
                try realm.write {
                    contact.firstName = firstName
                    contact.lastName = lastName
                    contact.phoneNumber = phoneNumber
                    realm.add(contact, update: .modified)
                }
                returnValue = contact
            }catch {
                // Error adding data
                returnValue = nil
            }
        }
        return returnValue
    }
    
    @discardableResult
    static func getAllContacts()->[Contact] {
        let realm: Realm = try! Realm()
        return Array(realm.objects(Contact.self))
    }
    
    
}
