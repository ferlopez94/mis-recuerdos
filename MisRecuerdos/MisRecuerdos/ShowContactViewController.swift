//
//  ShowContactViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 03/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
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
    var photos = [INSPhotoViewable]()
    let segueToEditContact = "segueToEditContact"
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(tap)
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.width / 2
        photoImage.image = contact.element.photo
        
        nameLabel.text = contact.element.name
        categoryLabel.text = contact.element.category == .family ? "Familiar" : "Conocido"
        birthdayLabel.text = contact.element.birthday
        commentsLabel.text = contact.element.comments == "" ? "No tienes comentarios acerca de esta persona." : contact.element.comments
        
        let photo = INSPhoto(image: contact.element.photo, thumbnailImage: contact.element.photo)
        photos.append(photo)
    }
    
    func showPhoto() {
        let currentPhoto = photos.first!
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto)
        
        let contactOverlayView = ContactOverlayView(frame: CGRect.zero)
        contactOverlayView.index = contact.offset
        galleryPreview.overlayView = contactOverlayView
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToEditContact {
            
        }
    }

}
