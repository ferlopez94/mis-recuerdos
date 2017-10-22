//
//  SignupViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    
    
    // MARK: - Instance variables
    
    var moveScrollView = false
    let commentsPlaceholder = "Comentarios acerca de ti..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTextView.delegate = self
        commentsTextView.text = commentsPlaceholder
        commentsTextView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardWillShow, object: nil);
    }
    
    
    // MARK: - IBActions
    
    @IBAction func createUser() {
        guard nameTextField.text != "",
            lastNameTextField.text != "",
            let name = nameTextField.text,
            let lastName = lastNameTextField.text else {
                return
        }
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
    }
    
    
    // MARK: - TextView delegate methods
    
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
