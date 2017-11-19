//
//  EditProfileViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 30/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class EditProfileViewController: SignupViewController {
    
    // MARK: - Instance variables
    
    var user: User!
    var delegateRootUser: RootUser?

    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = self.user else { return }

//        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
//            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
//                return
//        }
        
        self.user = user
        photoButton.layer.masksToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.height / 2

        nameTextField.text = user.name
        lastNameTextField.text = user.lastName
        dobTextField.text = user.dateOfBirth
        commentsTextView.text = user.comments == "" ? commentsPlaceholder : user.comments
        commentsTextView.textColor = UIColor.lightGray
    }

    
    override func createUser() {
        print("createUser")
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        guard nameTextField.text != "",
            let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir tu nombre."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard lastNameTextField.text != "",
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir tus apellidos."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard dobTextField.text != "",
            let dateOfBirth = dobTextField.text else {
                message = "Debes de introducir tu fecha de nacimiento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        let newPhotoImage = photoImage != nil ? photoImage! : user.photo
        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!

        guard photoImage == nil,
            name == user.name,
            lastName == user.lastName,
            dateOfBirth == user.dateOfBirth,
            comments == user.comments else {
                print("user data changed")
                let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
                let newUser = User(name: name, lastName: lastName, dateOfBirth: dateOfBirth, comments: comments, photo: newPhotoImage, contacts: user.contacts, events: user.events, allowEdition: user.allowEdition)
                
                if User.saveToFile(newUser, replaceAtIndex: index >= 0 ? index : 0) {
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newUser), forKey: K.Accounts.actualUserKey)
                    delegateRootUser?.modifyUser(newUser)
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
    
    @IBAction func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction override func textFieldEditingDidBegin(_ sender: UITextField) {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy/MM/dd"
        
        let minimumDate = dataFormatter.date(from: "1900/01/01")!
        let maximumDate = dataFormatter.date(from: "2015/01/01")!
        
        
        dataFormatter.dateStyle = .medium
        dataFormatter.timeStyle = .none
        let actualDate = dataFormatter.date(from: user.dateOfBirth)!
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = minimumDate
        datePickerView.date = actualDate
        datePickerView.maximumDate = maximumDate
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
}
