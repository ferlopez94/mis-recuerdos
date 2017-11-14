//
//  EditEventViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/12/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class EditEventViewController: AddEventViewController {
    
    @IBOutlet weak var relationTextFieldE: UITextField!
    @IBOutlet weak var songLabelE: UILabel!
    @IBOutlet weak var artistLabelE: UILabel!
    
    // MARK: - Instance variables
    
    var event: (offset: Int, element: Event)!
    var delegate: UpdateEvent?
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let event = self.event.element
        
        photoButton.layer.masksToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.height / 2
        
        nameTextField.text = event.name
        dobTextField.text = event.descript
        lastNameTextField.text = event.category == .personal ? "Personal" : "Otro"
        relationTextFieldE.text = event.relative
        commentsTextView.text = event.comments == "" ? commentsPlaceholder : event.comments
        commentsTextView.textColor = UIColor.lightGray
        songLabelE.text = event.song.title
        artistLabelE.text = event.song.artist
    }
    
    
    // Edit event
    override func createUser() {
        print("edit event")
        
        let event = self.event.element
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        guard nameTextField.text != "",
            let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir el nombre del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard lastNameTextField.text != "",
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir la categoría del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard dobTextField.text != "",
            let dateOfBirth = dobTextField.text else {
                message = "Debes de introducir la descripción del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        let newPhotoImage = photoImage != nil ? photoImage! : event.photo
        let category = lastName == "Personal" ? EventCategory.personal : EventCategory.other
        let relative = relationTextFieldE.text == relationTextFieldE.placeholder ? "" : relationTextFieldE.text!
        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!
        let song = songMedia! //M
        
        guard photoImage == nil,
            name == event.name,
            lastName == (event.category == .personal ? "Personal" : "Otro"),
            dateOfBirth == event.descript,
            relative == event.relative,
            song == event.song,
            comments == event.comments else {
                print("event data changed")
                
                guard let user = self.user else {
                    message = "No se pueden realizar cambios en este momento."
                    alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                    return
                }
                
                let newEvent = Event(name: name, descript: dateOfBirth, category: category, relative: relative, comments: comments, song: song, photo: newPhotoImage)
                
                user.addEvent(newEvent, atIndex: self.event.offset)
                let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
                
                if User.saveToFile(user, replaceAtIndex: index) {
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: K.Accounts.actualUserKey)
                    delegate?.update(event: (offset: self.event.offset, element: newEvent))
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
