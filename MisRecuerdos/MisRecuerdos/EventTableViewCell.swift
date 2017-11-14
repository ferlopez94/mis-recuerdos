//
//  EventTableViewCell.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    // MARK: - Instance methods
    
    func reset(withMessage message: String = "No has agregado eventos") {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = false
        }
        
        titleLabel.text = message
        subtitleLabel.text = ""
        photoImage.isHidden = true
    }
    
    func update(with event: Event) {
        if let constraint = (photoImage.constraints.filter { $0.firstAttribute == .height}.first) {
            constraint.isActive = true
        }
        
        photoImage.isHidden = false
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.image = event.photo
        titleLabel.text = event.name
        subtitleLabel.text = event.category == .personal ? "Personal" : "Otro"
    }

}
