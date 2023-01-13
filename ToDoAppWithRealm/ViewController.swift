//
//  ViewController.swift
//  ToDoAppWithRealm
//
//  Created by Sabbir Hossain on 13/1/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var contactListTableView: UITableView!
    var contacts = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }


    @IBAction func addContactButtonAction(_ sender: Any) {
        contactConfiguration(operationType: .add)
    }
    
    func contactConfiguration(operationType: ContactOperationType, index: Int = -1) {
        let alertTitle = operationType == .add ? "Add Contact": "Edit Contact"
        let alertMessage = operationType == .add ? "Enter your contact details" : "Update your contact details"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            if let firstName = alertController.textFields?[0].text, let lastName = alertController.textFields?[1].text, let phoneNumber = alertController.textFields?[2].text {
                if operationType == .add {
                     guard let id = Contact.getAllContacts().last?.id else { return }
                let contact = Contact(id: id + 1, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                Contact.add(contact: contact)
                self.contacts.append(contact)
                } else {
                    let contact = self.contacts[index]
                    let firstName = firstName.count == 0 ? contact.firstName : firstName
                    let lastName = lastName.count == 0 ? contact.lastName : lastName
                    let phoneNumber = phoneNumber.count == 0 ? contact.phoneNumber : phoneNumber
                    Contact.update(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                }
                self.contactListTableView.reloadData()
            }
            debugPrint("Saved!")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (firstNameField) in
            firstNameField.placeholder = "Enter your first name"
        }
        
        alertController.addTextField { (lastNameField) in
            lastNameField.placeholder = "Enter your last name"
        }
        
        alertController.addTextField { (phoneNumberField) in
            phoneNumberField.placeholder = "Enter your phone number"
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
}

enum ContactOperationType {
    case add
    case edit
}

extension ViewController {
    func configuration() {
        contacts = DatabaseHelper.shared.getAllContacts()
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as? ContactListCell else { return UITableViewCell() }
        cell.nameLabel.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
        cell.phoneLabel.text = contacts[indexPath.row].phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            debugPrint("In Edit Action")
            self.contactConfiguration(operationType: .edit, index: indexPath.row)
        }
        
        edit.backgroundColor = UIColor.red
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            debugPrint("Delete Action")
            DatabaseHelper.shared.deleteContact(contact: self.contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            self.contactListTableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, delete])
        return swipeConfiguration
    }
    
}

