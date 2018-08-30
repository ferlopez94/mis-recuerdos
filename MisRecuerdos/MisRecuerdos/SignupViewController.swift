//
//  SignupViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    
    
    // MARK: - Instance variables
    
    var photoImage: UIImage? = nil
    var moveScrollView = false
    var commentsPlaceholder = "Comentarios acerca de ti..."
    let segueToMenuIdentifier = "segueToMenu"
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoButton.layer.masksToBounds = true
        photoButton.layer.cornerRadius = photoButton.frame.width/2

        nameTextField.delegate = self
        lastNameTextField.delegate = self
        commentsTextView.delegate = self
        commentsTextView.text = commentsPlaceholder
        commentsTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardWillShow, object: nil);
    }
    
    
    // MARK: - IBActions
    
    @IBAction func importPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createUser() {
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        if photoImage == nil {
            photoImage = #imageLiteral(resourceName: "userProfile")
        }
            
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
        
        var dateOfBirth = ""
        
        if dobTextField.text != "" {
            dateOfBirth = dobTextField.text!
        }

        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!
        
        let user = User(name: name, lastName: lastName, dateOfBirth: dateOfBirth, comments: comments, photo: photoImage!)
        if User.saveToFile(user) {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: K.Accounts.actualUserKey)
            UserDefaults.standard.set(User.loadFromFile().count - 1, forKey: K.Accounts.actualUserIndexKey)
            performSegue(withIdentifier: segueToMenuIdentifier, sender: nil)
        } else {
            message = "No se puede crear una cuenta nueva en este momento."
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy/MM/dd"
        
        let minimumDate = dataFormatter.date(from: "1900/01/01")!
        let maximumDate = dataFormatter.date(from: "2015/01/01")!
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = minimumDate
        datePickerView.date = minimumDate
        datePickerView.maximumDate = maximumDate
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dobTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImage = image
            photoButton.setImage(photoImage, for: .normal)
            photoButton.setTitle("", for: .normal)
            photoButton.layer.borderWidth = 0.0
        } else {
            photoImage = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TextFieldDelegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - TextViewDelegate methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        moveScrollView = true
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if textView.text.isEmpty {
            textView.text = commentsPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
    // MARK: - Keyboard methods
    
    func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        if moveScrollView {
            moveScrollView = false
            scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height), animated: true)
        }
    }
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
    }
        
}
