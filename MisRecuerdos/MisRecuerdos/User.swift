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
    override var description: String {
        return "\(name) \(lastName) \(dateOfBirth)"
    }
    
    
    // MARK: - Initializers
    
    init(name: String, lastName: String, dateOfBirth: String, comments: String, photo: UIImage) {
        self.name = name
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.comments = comments
        self.photo = photo
        self.photoData = UIImageJPEGRepresentation(photo, 0.5)!
    }
    
    
    // MAKR: - Coding
    
    struct PropertyKey {
        static let name = "name"
        static let lastName = "lastName"
        static let dateOfBirth = "dateOfBirth"
        static let comments = "comments"
        static let photoData = "photoData"
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastName) as? String,
            let dateOfBirth = aDecoder.decodeObject(forKey: PropertyKey.dateOfBirth) as? String,
            let comments = aDecoder.decodeObject(forKey: PropertyKey.comments) as? String,
            let photoData = aDecoder.decodeObject(forKey: PropertyKey.photoData) as? Data,
            let photo = UIImage(data: photoData) else { return nil }
        
        self.init(name: name, lastName: lastName, dateOfBirth: dateOfBirth, comments: comments, photo: photo)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(lastName, forKey: PropertyKey.lastName)
        aCoder.encode(dateOfBirth, forKey: PropertyKey.dateOfBirth)
        aCoder.encode(comments, forKey: PropertyKey.comments)
        aCoder.encode(photoData, forKey: PropertyKey.photoData)
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

}
