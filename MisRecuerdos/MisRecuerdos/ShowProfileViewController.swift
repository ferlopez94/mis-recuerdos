//
//  ShowProfileViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 30/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

class ShowProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

    
    // MARK: - Instance variables
    
    var photos = [INSPhotoViewable]()
    
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(tap)
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.image = user.photo
        nameLabel.text = user.name
        lastNameLabel.text = user.lastName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = formatter.date(from: user.dateOfBirth)!
        formatter.dateStyle = .long
        dobLabel.text = formatter.string(from: date)
        commentsLabel.text = user.comments == "" ? "No tienes comentarios acerca de ti." : user.comments
        
        let photo = INSPhoto(image: user.photo, thumbnailImage: user.photo)
        photos.append(photo)
    }
    
    func showPhoto() {
        let currentPhoto = photos.first!
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto)
        
        let contactOverlayView = ContactOverlayView(frame: CGRect.zero)
        galleryPreview.overlayView = contactOverlayView
        
        present(galleryPreview, animated: true, completion: nil)
    }

}
