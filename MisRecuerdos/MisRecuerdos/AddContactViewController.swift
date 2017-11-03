//
//  AddContactViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class AddContactViewController: SignupViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Instance variables
    
    var user: User? = nil
    override var commentsPlaceholder: String {
        get {
            return "Comentarios acerca de la persona..."
        }
        set {
            
        }
    }
    
    let relationshipOptions = ["Familiar", "Conocido"]
    let relationshipPickerView = UIPickerView()
    
    let months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    var numberOfDays = 31
    let birthdayPickerView = UIPickerView()
    
    let segueAfterAddIdentifier = "unwindToContactsAfterAddNewContact"
    
    
    // MARK: - View Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        relationshipPickerView.delegate = self
        birthdayPickerView.delegate = self
        lastNameTextField.inputView = relationshipPickerView
        dobTextField.inputView = birthdayPickerView

        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
    }
    
    // Add new contact
    override func createUser() {
        print("Add contact")
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        guard user != nil else {
            message = "No puede agregar una persona en este momento."
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard photoImage != nil else {
            message = "Debes de seleccionar una foto de perfil para la persona."
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
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
        
        let category = lastName == "Familiar" ? ContactCategory.family : ContactCategory.known
        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!
        
        print(name)
        print(lastName)
        print(dateOfBirth)
        print(comments)
        
        let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
        let contact = Contact(name: name, birthday: dateOfBirth, category: category, comments: comments, photo: photoImage!)
        user!.addContact(contact)
        
        if User.saveToFile(user!, replaceAtIndex: index) {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user!), forKey: K.Accounts.actualUserKey)
            performSegue(withIdentifier: segueAfterAddIdentifier, sender: nil)
        } else {
            message = "No se pueden realizar cambios en este momento."
            alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // Cancel add new contact
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == relationshipPickerView {
            return 1
        } else if pickerView == birthdayPickerView {
            return 2
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == relationshipPickerView && component == 0 {
            return relationshipOptions.count
        } else if pickerView == birthdayPickerView {
            if component == 0 {
                return numberOfDays
            } else {
                return months.count
            }
        }

        
        return 0
    }
    
    
    // MARK: - UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == relationshipPickerView {
            return relationshipOptions[row]
        } else if pickerView == birthdayPickerView {
            if component == 0 {
                return String(describing: row + 1)
            } else {
                return months[row]
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == relationshipPickerView && component == 0 {
            lastNameTextField.text = relationshipOptions[row]
        } else if pickerView == birthdayPickerView {
            if component == 1 {
                switch row {
                case 0, 2, 4, 6, 7, 9, 11:
                    numberOfDays = 31
                case 1:
                    numberOfDays = 29
                default:
                    numberOfDays = 30
                    break
                }
                
                birthdayPickerView.reloadComponent(0)
            }
            
            let daySelected = birthdayPickerView.selectedRow(inComponent: 0) + 1
            let monthSelected = birthdayPickerView.selectedRow(inComponent: 1)
            let birthday = "\(daySelected) de \(months[monthSelected])"
            dobTextField.text = birthday
        }
    }
    
    override func textFieldEditingDidBegin(_ sender: UITextField) {}

}
