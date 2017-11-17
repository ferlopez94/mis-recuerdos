//
//  ShowContactViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 03/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

protocol UpdateContact {
    func update(contact: (offset: Int, element: Contact))
}

class ShowContactViewController: UIViewController, UpdateContact {

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
    var delegate: UpdateContact?
    var delegateReload: ReloadData?
    var allowEdition = false
    
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        allowEdition = UserDefaults.standard.bool(forKey: K.Settings.allowEditionKey)
    }
    
    func showPhoto() {
        let currentPhoto = photos.first!
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto)
        
        let contactOverlayView = ContactOverlayView(frame: CGRect.zero)
        contactOverlayView.index = contact.offset
        galleryPreview.overlayView = contactOverlayView
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
    
    // MARK: - UpdateContact methods
    
    func update(contact: (offset: Int, element: Contact)) {
        self.contact = contact
        self.delegate?.update(contact: contact)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard allowEdition else {
            let title = "Modo de edición desactivado"
            let message = "Para activar el modo de edición ve a tu perfil."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToEditContact {
            let vc = segue.destination as! EditContactViewController
            vc.contact = contact
            vc.delegate = self
            vc.delegateReload = delegateReload
        }
    }

}
