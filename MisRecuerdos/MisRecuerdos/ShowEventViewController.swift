//
//  ShowEventViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

protocol UpdateEvent {
    func update(event: (offset: Int, element: Event))
}

class ShowEventViewController: UIViewController, UpdateEvent {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var relativeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    // MARK: - Instance variables
    
    var event: (offset: Int, element: Event)!
    var photos = [INSPhotoViewable]()
    let segueToEditEvent = "segueToEditEvent"
    var delegate: UpdateEvent?
    
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(tap)
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.width / 2
        photoImage.image = event.element.photo
        
        nameLabel.text = event.element.name
        descriptLabel.text = event.element.descript
        categoryLabel.text = event.element.category == .personal ? "Personal" : "Otro"
        relativeLabel.text = event.element.relative
        commentsLabel.text = event.element.comments == "" ? "No tienes comentarios acerca de este evento." : event.element.comments
        songLabel.text = event.element.song.title
        artistLabel.text = event.element.song.artist
        
        let photo = INSPhoto(image: event.element.photo, thumbnailImage: event.element.photo)
        photos.append(photo)
    }
    
    func showPhoto() {
        let currentPhoto = photos.first!
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto)
        
        let eventOverlayView = EventOverlayView(frame: CGRect.zero)
        eventOverlayView.index = event.offset
        galleryPreview.overlayView = eventOverlayView
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
    
    // MARK: - UpdateEvent methods
    
    func update(event: (offset: Int, element: Event)) {
        self.event = event
        self.delegate?.update(event: event)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToEditEvent {
            let ve = segue.destination as! EditEventViewController
            ve.event = event
            ve.delegate = self
        }
    }
    
}

