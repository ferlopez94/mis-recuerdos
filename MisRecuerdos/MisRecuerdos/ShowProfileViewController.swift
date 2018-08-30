//
//  ShowProfileViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 30/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

class ShowProfileViewController: UIViewController, RootUser {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var allowEditionSwitch: UISwitch!

    
    // MARK: - Instance variables
    
    var photos = [INSPhotoViewable]()
    var user: User?
    var delegateRootUser: RootUser?
    let segueToEditProfile = "segueToEditProfile"
    
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = self.user else { return }
        print(user.allowEdition)
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
        let date = user.dateOfBirth == "" ? formatter.date(from: "Jan 01, 2000")! : formatter.date(from: user.dateOfBirth)!
        formatter.dateStyle = .long
        dobLabel.text = user.dateOfBirth == "" ? "No ingresado" : formatter.string(from: date)
        commentsLabel.text = user.comments == "" ? "No tienes comentarios acerca de ti." : user.comments
        
        let photo = INSPhoto(image: user.photo, thumbnailImage: user.photo)
        photos.append(photo)
        allowEditionSwitch.isOn = user.allowEdition
    }
    
    func showPhoto() {
        let currentPhoto = photos.first!
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto)
        
        let contactOverlayView = ContactOverlayView(frame: CGRect.zero)
        galleryPreview.overlayView = contactOverlayView
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
    @IBAction func segueToEdit(_ sender: Any) {
        guard let user = self.user else { return }

        guard user.allowEdition else {
            let title = "Modo de edición desactivado"
            let message = "Para activar el modo de edición habilita el campo \"Editar datos\"."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: segueToEditProfile, sender: sender)
    }
    
    
    @IBAction func allowEdition(_ sender: UISwitch) {
        guard let user = self.user else { return }
        user.allowEdition = sender.isOn
        UserDefaults.standard.set(user.allowEdition, forKey: K.Settings.allowEditionKey)
        delegateRootUser?.modifyUser(user)
        
        let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
        if User.saveToFile(user, replaceAtIndex: index) {
            print("user saved!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EditProfileViewController
        vc.user = self.user
        vc.delegateRootUser = self
    }
    
    
    // MARK: - RootUser methods
    
    func modifyUser(_ user: User) {
        self.user = user
        self.delegateRootUser?.modifyUser(user)
    }
    
}
