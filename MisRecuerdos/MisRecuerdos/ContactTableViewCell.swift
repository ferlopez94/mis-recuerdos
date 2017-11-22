//
//  ContactTableViewCell.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 03/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    // MARK: - Instance methods

    func reset(withMessage message: String = "No has agregado personas") {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = false
        }
        
        titleLabel.text = message
        subtitleLabel.text = ""
        photoImage.isHidden = true
    }
    
    func update(with contact: Contact) {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = true
        }
        
        photoImage.isHidden = false
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.image = contact.photo
        titleLabel.text = contact.name
        subtitleLabel.text = contact.category.rawValue
    }

}
