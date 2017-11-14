//
//  Event.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import MediaPlayer

enum EventCategory: String {
    case personal, other
}

final class Event: NSObject, NSCoding {
    
    // MARK: - Instance properties
    
    let name: String
    let descript: String
    let category: EventCategory
    let relative: String
    let comments: String
    let song: MPMediaItem?
    let photo: UIImage
    let photoData: Data
    
    override var description: String {
        return "Nombre: \(name). Descripción: \(descript). Categoría: \(category.rawValue)"
    }
    
    
    // MARK: - Initializers
    
    init(name: String, descript: String, category: EventCategory, relative: String, comments: String, song: MPMediaItem?, photo: UIImage) {
        self.name = name
        self.descript = descript
        self.category = category
        self.relative = relative
        self.comments = comments
        self.song = song
        self.photo = photo
        self.photoData = UIImageJPEGRepresentation(photo, 0.2)!
    }
    
    
    // MAKR: - Coding
    
    struct PropertyKey {
        static let name = "name"
        static let descript = "descript"
        static let category = "category"
        static let relative = "relative"
        static let comments = "comments"
        static let song = "song"
        static let photoData = "photoData"
    }
    
    convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let descript = aDecoder.decodeObject(forKey: PropertyKey.descript) as? String,
            let categoryRawValue = aDecoder.decodeObject(forKey: PropertyKey.category) as? String,
            let category = EventCategory.init(rawValue: categoryRawValue),
            let relative = aDecoder.decodeObject(forKey: PropertyKey.relative) as? String,
            let comments = aDecoder.decodeObject(forKey: PropertyKey.comments) as? String,
            let song = aDecoder.decodeObject(forKey: PropertyKey.song) as? MPMediaItem?,
            let photoData = aDecoder.decodeObject(forKey: PropertyKey.photoData) as? Data,
            let photo = UIImage(data: photoData) else { return nil }
        
        self.init(name: name, descript: descript, category: category, relative: relative, comments: comments, song: song, photo: photo)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(descript, forKey: PropertyKey.descript)
        aCoder.encode(category.rawValue, forKey: PropertyKey.category)
        aCoder.encode(relative, forKey: PropertyKey.relative)
        aCoder.encode(comments, forKey: PropertyKey.comments)
        aCoder.encode(song, forKey: PropertyKey.song)
        aCoder.encode(photoData, forKey: PropertyKey.photoData)
    }
}
