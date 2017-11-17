//
//  GameConfigurationViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import INSPhotoGallery
import GameplayKit

class GameConfigurationViewController: UIViewController {

    
    @IBOutlet weak var numQuestionsLabel: UILabel!
    @IBOutlet weak var scSong: UISegmentedControl!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    
    
    var contactsList = [Contact]()
    var eventsList = [Event]()
    var numQuestions = 4
    var contacts = [(offset: Int, element: Contact)]()
    var events = [(offset: Int, element: Event)]()
    var questionsList = [Question]()
    var photosList = [INSPhotoViewable]()
    var numContacts = 0
    var numEvents = 0
    var numSound = 1
    var numSoundS = 2
    var numSoundSS = 3
    var valor = 0
    var counter = 4
    var totalElements = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numQuestionsLabel.text = "\(numQuestions)"
        decrementButton.isEnabled = false
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        contactsList = user.contacts
        eventsList = user.events
        
        if contactsList.count >= 4 && eventsList.count >= 4 {
            totalElements = contactsList.count + eventsList.count
        }
        else if contactsList.count >= 4 {
            totalElements = contactsList.count
        }
        else if eventsList.count >= 4 {
            totalElements = eventsList.count
        }
        
        self.title = ""
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        questionsList.removeAll()
        numContacts = contactsList.count
        numEvents = eventsList.count
        if numContacts >= 4 || numEvents >= 4 {
            getQuestions()
        }
        else {
            valor = Int(numQuestionsLabel.text!)!
            if numContacts < 4 {
                let alert = UIAlertController(title: "Error", message: "No hay informacion suficiente para comenzar el juego", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    func getQuestions() {
        var contactsName = [String]()
        var eventsName = [String]()
        var name: String!
        var random: Int!
        var questionType: String!
        var n = 0
        
        while n < numContacts {
            name = (contactsList[n]).value(forKey: "name") as! String
            contactsName.append(name)
            n += 1
        }
        n = 0
        while n < numEvents {
            name = (eventsList[n]).value(forKey: "name") as! String
            eventsName.append(name)
            n += 1
        }
        while numQuestions > 0 {
            if contactsName.count >= 4 && numContacts > 0 && numQuestions > 0 {
                questionType = "Contacto"
                random = Int(arc4random() % UInt32(numContacts))
                let contact = contactsList[random]
                contactsList.remove(at: random)
                getAnswers(contact: contact, contactsName: contactsName, questionType: questionType)
                numQuestions -= 1
                numContacts -= 1
            }
            if eventsName.count >= 4 && numEvents > 0 && numQuestions > 0 {
                questionType = "Evento"
                random = Int(arc4random() % UInt32(numEvents))
                let event = eventsList[random]
                eventsList.remove(at: random)
                getAnswersE(contact: event, contactsName: eventsName, questionType: questionType)
                numQuestions -= 1
                numEvents -= 1
            }
        }
    }
    
    func getAnswers(contact: Contact, contactsName: [String], questionType: String) {
        var contactsName = contactsName
        let descripQuestion = ""
        var correctAnswer: String!
        //if questionType == "Contacto" {
            //descripQuestion = contact.value(forKey: "comments") as! String
            correctAnswer = contact.value(forKey: "name") as! String
        //} else {
            correctAnswer = (contact.value(forKey: "name") as! String)
        //}
        let photo = contact.value(forKey: "photo") as! UIImage
 
        var answersList = ["","","",""]
        let placeCorrect = Int(arc4random() % 4)
        answersList[placeCorrect] = correctAnswer
        
        var placeIncorrect = 0
        var randomAnswer: Int!
        while placeIncorrect < 4 {
            if placeCorrect != placeIncorrect {
                randomAnswer = Int(arc4random() % UInt32(contactsName.count))
                if(contactsName[randomAnswer] == correctAnswer) {
                    contactsName.remove(at: randomAnswer)
                }
                else {
                    answersList[placeIncorrect] = contactsName[randomAnswer]
                    contactsName.remove(at: randomAnswer)
                    placeIncorrect += 1
                }
            }
            else {
                placeIncorrect += 1
            }
        }
        
        let question = Question(descrip: descripQuestion, answersList: answersList, answer: placeCorrect, photo: photo, questionType: questionType)
        questionsList.append(question)
    }
    
    func getAnswersE(contact: Event, contactsName: [String], questionType: String) {
        print("Llamando a eventos")
        var contactsName = contactsName
        let descripQuestion = ""
        var correctAnswer: String!
        //if questionType == "Evento" {
            //descripQuestion = contact.value(forKey: "comments") as! String
            //correctAnswer = contact.value(forKey: "name") as! String
        //} else {
            correctAnswer = (contact.value(forKey: "name") as! String)
        //}
        let photo = contact.value(forKey: "photo") as! UIImage
        
        var answersList = ["","","",""]
        let placeCorrect = Int(arc4random() % 4)
        answersList[placeCorrect] = correctAnswer
        
        var placeIncorrect = 0
        var randomAnswer: Int!
        while placeIncorrect < 4 {
            if placeCorrect != placeIncorrect {
                randomAnswer = Int(arc4random() % UInt32(contactsName.count))
                if(contactsName[randomAnswer] == correctAnswer) {
                    contactsName.remove(at: randomAnswer)
                }
                else {
                    answersList[placeIncorrect] = contactsName[randomAnswer]
                    contactsName.remove(at: randomAnswer)
                    placeIncorrect += 1
                }
            }
            else {
                placeIncorrect += 1
            }
        }
        
        let question = Question(descrip: descripQuestion, answersList: answersList, answer: placeCorrect, photo: photo, questionType: questionType)
        questionsList.append(question)
    }
    
    
    //MARK: - Questions buttons actions
    
    
    @IBAction func decrementQuestions(_ sender: UIButton) {
        if counter == 4 {
            decrementButton.isEnabled = false
            let alert = UIAlertController(title: "Error", message: "El número mínimo de preguntas debe ser cuatro", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            counter -= 1
            numQuestionsLabel.text = "\(counter)"
            numQuestions = counter
            incrementButton.isEnabled = true
        }
    }
    
    @IBAction func incrementQuestions(_ sender: UIButton) {
        if counter < totalElements {
            counter += 1
            numQuestionsLabel.text = "\(counter)"
            numQuestions = counter
            decrementButton.isEnabled = true
        }
        else {
            incrementButton.isEnabled = false
            let alert = UIAlertController(title: "Error", message: "Ya no puedes incrementar el número de preguntas porque no tienes sufiecientes contactos o eventos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendToQuestions"{
            if scSong.selectedSegmentIndex == 0{
                
            let viewQuestions = segue.destination as! GameQuestionsViewController
            viewQuestions.Questions = questionsList
            viewQuestions.sound = numSound
            }
            else if scSong.selectedSegmentIndex == 1{
                
                let viewQuestions = segue.destination as! GameQuestionsViewController
                viewQuestions.Questions = questionsList
                viewQuestions.sound = numSoundS
            }
            if scSong.selectedSegmentIndex == 2{
                
                let viewQuestions = segue.destination as! GameQuestionsViewController
                viewQuestions.Questions = questionsList
                viewQuestions.sound = numSoundSS
            }
        }
    }
    
}
