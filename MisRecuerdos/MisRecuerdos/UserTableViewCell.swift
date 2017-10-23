//
//  UserTableViewCell.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!


    // MARK: - Instance methods
    
    func reset() {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = false
        }
        
        nameLabel.text = "No se ha creado ninguna cuenta"
    }
    
    func update(with user: User) {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = true
        }
        
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.image = user.photo
        nameLabel.text = "\(user.name) \(user.lastName)"
    }

}
