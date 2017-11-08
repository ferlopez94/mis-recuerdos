//
//  Contact.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

enum ContactCategory: String {
    case family, known
}

final class Contact: NSObject, NSCoding {
    
    // MARK: - Instance properties
    
    let name: String
    let birthday: String
    let category: ContactCategory
    let comments: String
    let photo: UIImage
    let photoData: Data
    override var description: String {
        return "Nombre: \(name). Cumpleaños: \(birthday). Relación: \(category.rawValue)"
    }
    
    
    // MARK: - Initializers
    
    init(name: String, birthday: String, category:  ContactCategory, comments: String, photo: UIImage) {
        self.name = name
        self.birthday = birthday
        self.category = category
        self.comments = comments
        self.photo = photo
        self.photoData = UIImageJPEGRepresentation(photo, 0.2)!
    }
    
    
    // MAKR: - Coding
    
    struct PropertyKey {
        static let name = "name"
        static let birthday = "birthday"
        static let category = "category"
        static let comments = "comments"
        static let photoData = "photoData"
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let birthday = aDecoder.decodeObject(forKey: PropertyKey.birthday) as? String,
            let categoryRawValue = aDecoder.decodeObject(forKey: PropertyKey.category) as? String,
            let category = ContactCategory.init(rawValue: categoryRawValue),
            let comments = aDecoder.decodeObject(forKey: PropertyKey.comments) as? String,
            let photoData = aDecoder.decodeObject(forKey: PropertyKey.photoData) as? Data,
            let photo = UIImage(data: photoData) else { return nil }
        
        self.init(name: name, birthday: birthday, category: category, comments: comments, photo: photo)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(birthday, forKey: PropertyKey.birthday)
        aCoder.encode(category.rawValue, forKey: PropertyKey.category)
        aCoder.encode(comments, forKey: PropertyKey.comments)
        aCoder.encode(photoData, forKey: PropertyKey.photoData)
    }
    
}
