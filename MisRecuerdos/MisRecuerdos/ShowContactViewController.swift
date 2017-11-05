//
//  ShowContactViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 03/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ShowContactViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    // MARK: - Instance variables
    
    var contact: (offset: Int, element: Contact)!
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.width / 2
        photoImage.image = contact.element.photo
        
        nameLabel.text = contact.element.name
        categoryLabel.text = contact.element.category == .family ? "Familiar" : "Conocido"
        birthdayLabel.text = contact.element.birthday
        commentsLabel.text = contact.element.comments == "" ? "No tienes comentarios acerca de esta persona." : contact.element.comments
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
