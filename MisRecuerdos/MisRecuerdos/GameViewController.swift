//
//  GameViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//


import UIKit
import INSPhotoGallery
import GameplayKit


protocol UpdateSettings {
    func update(numQuestions: Int, sound: Int)
}

class GameViewController: UIViewController, UpdateSettings {

    var contactsList = [Contact]()
    var eventsList = [Event]()
    var numQuestions = 4
    var contacts = [(offset: Int, element: Contact)]()
    var events = [(offset: Int, element: Event)]()
    var questionsList = [Question]()
    var photosList = [INSPhotoViewable]()
    var numContacts = 0
    var numEvents = 0
    var valor = 0
    var totalElements = 0
    var sound = 1
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        self.user = user
        contactsList = user.contacts
        eventsList = user.events
        
        print(contactsList)
        print(eventsList)
        if contactsList.count >= 4 && eventsList.count >= 4 {
            totalElements = contactsList.count + eventsList.count
        }
        else if contactsList.count >= 4 {
            totalElements = contactsList.count
        }
        else if eventsList.count >= 4 {
            totalElements = eventsList.count
        }
        print(totalElements)
        
        
        self.title = ""
    }

    @IBAction func unwindToMenuGame(segue: UIStoryboardSegue) {
        numQuestions = 4
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToConfigureGame" {
            let viewConfiguration = segue.destination as! GameConfigurationViewController
            viewConfiguration.tElements = totalElements
            viewConfiguration.nQuestions = numQuestions
            viewConfiguration.delegate = self
            viewConfiguration.user = user
        }
        else if segue.identifier == "segueToQuestions" {
            questionsList.removeAll()
            contactsList = (user?.contacts)!
            eventsList = (user?.events)!
            numContacts = contactsList.count
            numEvents = eventsList.count
            
            if numContacts >= 4 || numEvents >= 4 {
                if (user?.numQuestions)! >= numContacts || (user?.numQuestions)! >= numEvents {
                    numQuestions = (user?.numQuestions)!
                }
                else {
                    numQuestions = 4
                }
                if (user?.sound != 0) {
                    sound = (user?.sound)!
                }
                getQuestions()
            }
            /*if numContacts >= 4 || numEvents >= 4 {
                if (user?.numQuestions != 0) {
                    numQuestions = (user?.numQuestions)!
                }
                if (user?.sound != 0) {
                    sound = (user?.sound)!
                }
                getQuestions()
            }*/
            else {
                valor = numQuestions
                if numContacts < 4 {
                    let alert = UIAlertController(title: "Error", message: "No hay informacion suficiente para comenzar el juego, accede a configuración del juego",preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
            let viewQuestions = segue.destination as! GameQuestionsViewController
            viewQuestions.Questions = questionsList
            viewQuestions.sound = sound
        }
    }
    
    func getQuestions() {
        var contactsName = [String]()
        var eventsName = [String]()
        var name: String!
        var random: Int!
        var questionType: String!
        var n = 0
        var categor: ContactCategory
        var contactsCategory = [String]()
        
        while n < numContacts {
            name = (contactsList[n]).value(forKey: "name") as! String
            //categor = (contactsList[n]).value(forKey: "category") as! ContactCategory
            categor =  contactsList[n].category
            contactsName.append(name)
            contactsCategory.append(categor.rawValue)
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
                getAnswers(contact: contact, contactsName: contactsName, questionType: questionType)
                numQuestions -= 1
                
                if numQuestions > 0 {
                    questionType = "Categoria"
                    random = Int(arc4random() % UInt32(numContacts))
                    let categor = contactsList[random]
                    getAnswersC(contact: categor, contactsName: contactsCategory, questionType: questionType)
                }
                
                contactsList.remove(at: random)
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
        correctAnswer = contact.value(forKey: "name") as! String
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
    
    func getAnswersC(contact: Contact, contactsName: [String], questionType: String) {
        var contactsName = contactsName
        let descripQuestion = ""
        var correctAnswer: String!
        correctAnswer = contact.category.rawValue
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
    
    func update(numQuestions: Int, sound: Int) {
        self.user?.numQuestions = numQuestions
        self.user?.sound = sound
    }

}
