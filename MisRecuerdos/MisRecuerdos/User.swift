//
//  User.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

final class User: NSObject, NSCoding {
    
    // MARK: - Type properties
    
    static let pathToFile = "users"
    
    
    // MARK: - Instance properties
    
    let name: String
    let lastName: String
    let dateOfBirth: String
    let comments: String
    let photo: UIImage
    let photoData: Data
    var contacts: [Contact]
    var events: [Event]
    var allowEdition: Bool
    var numQuestions: Int
    var sound: Int
    override var description: String {
        return "\(name) \(lastName) \(dateOfBirth)"
    }
    
    
    // MARK: - Initializers
    
    init(name: String, lastName: String, dateOfBirth: String, comments: String, photo: UIImage, contacts: [Contact] = [Contact](), events: [Event] = [Event](), allowEdition: Bool = false, numQuestions: Int = 4, sound: Int = 1) {
        self.name = name
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.comments = comments
        self.photo = photo
        self.photoData = UIImageJPEGRepresentation(photo, 0.2)!
        self.contacts = contacts
        self.events = events
        self.allowEdition = allowEdition
        self.numQuestions = numQuestions
        self.sound = sound
    }
    
    
    // MAKR: - Coding
    
    struct PropertyKey {
        static let name = "name"
        static let lastName = "lastName"
        static let dateOfBirth = "dateOfBirth"
        static let comments = "comments"
        static let photoData = "photoData"
        static let contacts = "contacts"
        static let events = "events"
        static let allowEdition = "allowEdition"
        static let numQuestions = "numQuestions"
        static let sound = "sound"
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        let allowEdition = aDecoder.decodeBool(forKey: PropertyKey.allowEdition)
        let numQuestions = aDecoder.decodeInteger(forKey: PropertyKey.numQuestions)
        let sound = aDecoder.decodeInteger(forKey: PropertyKey.sound)
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String,
            let dateOfBirth = aDecoder.decodeObject(forKey: PropertyKey.dateOfBirth) as? String,
            let comments = aDecoder.decodeObject(forKey: PropertyKey.comments) as? String,
            let photoData = aDecoder.decodeObject(forKey: PropertyKey.photoData) as? Data,
            let photo = UIImage(data: photoData),
            let contacts = aDecoder.decodeObject(forKey: PropertyKey.contacts) as? [Contact],
            let events = aDecoder.decodeObject(forKey: PropertyKey.events) as? [Event] else { return nil
        }
        
        self.init(name: name, lastName: lastName, dateOfBirth: dateOfBirth, comments: comments, photo: photo, contacts: contacts, events: events, allowEdition: allowEdition, numQuestions: numQuestions, sound: sound)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(dateOfBirth, forKey: PropertyKey.dateOfBirth)
        aCoder.encode(comments, forKey: PropertyKey.comments)
        aCoder.encode(photoData, forKey: PropertyKey.photoData)
        aCoder.encode(contacts, forKey: PropertyKey.contacts)
        aCoder.encode(events, forKey: PropertyKey.events)
        aCoder.encode(allowEdition, forKey: PropertyKey.allowEdition)
        aCoder.encode(numQuestions, forKey: PropertyKey.numQuestions)
        aCoder.encode(sound, forKey: PropertyKey.sound)
    }
    
    
    // MARK: - Type methods
    
    static func removeAllUsers() -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userDirectory = documentsDirectory.appendingPathComponent(User.pathToFile)
        
        let users = [User]()
        
        return NSKeyedArchiver.archiveRootObject(users, toFile: userDirectory.path)
    }
    
    static func saveToFile(_ user: User) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userDirectory = documentsDirectory.appendingPathComponent(User.pathToFile)
        
        var users = User.loadFromFile()
        users.append(user)
        
        return NSKeyedArchiver.archiveRootObject(users, toFile: userDirectory.path)
    }
    
    static func saveToFile(_ user: User, replaceAtIndex index: Int) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userDirectory = documentsDirectory.appendingPathComponent(User.pathToFile)
        
        var users = User.loadFromFile()
        users[index] = user
        
        return NSKeyedArchiver.archiveRootObject(users, toFile: userDirectory.path)
    }
    
    static func loadFromFile() -> [User] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let userDirectory = documentsDirectory.appendingPathComponent(User.pathToFile)
        let users = NSKeyedUnarchiver.unarchiveObject(withFile: userDirectory.path) as? [User]
        
        if users == nil {
            return [User]()
        } else {
            return users!
        }
    }
    
    
    // MARK: - Contacts
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        contacts.sort {$0.name < $1.name}
    }
    
    func addContact(_ contact: Contact, atIndex index: Int) {
        contacts[index] = contact
    }
    
    func removeContact(atIndex index: Int) {
        contacts.remove(at: index)
    }
    
    func getFamilyContacts() -> [(offset: Int, element: Contact)] {
        return self.contacts.enumerated().filter {
            $0.element.category == .family
            || $0.element.category == .family
            || $0.element.category == .Abuelo
            || $0.element.category == .Abuela
            || $0.element.category == .Padre
            || $0.element.category == .Madre
            || $0.element.category == .Hermano
            || $0.element.category == .Hermana
            || $0.element.category == .Esposo
            || $0.element.category == .Esposa
            || $0.element.category == .Hijo
            || $0.element.category == .Hija
            || $0.element.category == .Tío
            || $0.element.category == .Tía
            || $0.element.category == .Nieto
            || $0.element.category == .Nieta
        }
    }
    
    func getKnownContacts() -> [(offset: Int, element: Contact)] {
        return self.contacts.enumerated().filter {
            $0.element.category == .known
            || $0.element.category == .Amigo
            || $0.element.category == .Amiga
            || $0.element.category == .Vecino
            || $0.element.category == .Vecina
            || $0.element.category == .Doctor
            || $0.element.category == .Doctora
            || $0.element.category == .Enfermero
            || $0.element.category == .Enfermera
            || $0.element.category == .Actor
            || $0.element.category == .Actriz
            || $0.element.category == .Cantante
        }
    }

    
    
    // MARK: - Events
    
    func addEvent(_ event: Event) {
        events.append(event)
        events.sort {$0.name < $1.name}
    }
    
    func addEvent(_ event: Event, atIndex index: Int) {
        events[index] = event
    }
    
    func removeEvent(atIndex index: Int) {
        events.remove(at: index)
    }

}
