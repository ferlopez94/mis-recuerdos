//
//  EditContactViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 06/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class EditContactViewController: AddContactViewController {
    
    // MARK: - Instance variables
    
    var contact: (offset: Int, element: Contact)!
    var delegate: UpdateContact?
    

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let contact = self.contact.element
        
        photoButton.layer.masksToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.height / 2
        
        nameTextField.text = contact.name
        lastNameTextField.text = contact.category == .family ? "Familiar" : "Conocido"
        dobTextField.text = contact.birthday
        commentsTextView.text = contact.comments == "" ? commentsPlaceholder : contact.comments
        commentsTextView.textColor = UIColor.lightGray
    }

    
    // Edit contact
    override func createUser() {
        print("edit contact")
        
        let contact = self.contact.element
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        guard nameTextField.text != "",
            let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir el nombre de la persona."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard lastNameTextField.text != "",
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir la relación que tienes con la persona."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard dobTextField.text != "",
            let dateOfBirth = dobTextField.text else {
                message = "Debes de introducir la fecha de cumpleaños de la persona."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        let newPhotoImage = photoImage != nil ? photoImage! : contact.photo
        let category = lastName == "Familiar" ? ContactCategory.family : ContactCategory.known
        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!
        
        guard photoImage == nil,
            name == contact.name,
            lastName == (contact.category == .family ? "Familiar" : "Conocido"),
            dateOfBirth == contact.birthday,
            comments == contact.comments else {
                print("contact data changed")
                
                guard let user = self.user else {
                    message = "No se pueden realizar cambios en este momento."
                    alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                    return
                }
                
                let newContact = Contact(name: name, birthday: dateOfBirth, category: category, comments: comments, photo: newPhotoImage)
                
                user.addContact(newContact, atIndex: self.contact.offset)
                let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
            
                if User.saveToFile(user, replaceAtIndex: index) {
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: K.Accounts.actualUserKey)
                    delegate?.update(contact: (offset: self.contact.offset, element: newContact))
                    dismiss(animated: true, completion: nil)
                } else {
                    message = "No se pueden realizar cambios en este momento."
                    alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
                
                return
        }
        
        dismiss(animated: true, completion: nil)
    }

}
