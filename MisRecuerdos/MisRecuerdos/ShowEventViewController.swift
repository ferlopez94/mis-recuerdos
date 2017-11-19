//
//  ShowEventViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit
import MediaPlayer
import AVFoundation

protocol UpdateEvent {
    func update(event: (offset: Int, element: Event))
}

class ShowEventViewController: UIViewController, UpdateEvent, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var relativeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    // MARK: - Instance variables
    
    var event: (offset: Int, element: Event)!
    var photos = [INSPhotoViewable]()
    let segueToEditEvent = "segueToEditEvent"
    var delegate: UpdateEvent?
    var delegateReload: ReloadDataE?
    
    var audioPlayer: AVAudioPlayer!
    var reproducing = false
    var change = false
    var songMedia: MPMediaItem! = nil
    var allowEdition = false
    
    
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
        songLabel.text = event.element.song?.title ?? "Canción no asociada"
        
        if event.element.song == nil {
            playButton.alpha = 0.0
        }
        
        let photo = INSPhoto(image: event.element.photo, thumbnailImage: event.element.photo)
        photos.append(photo)
        allowEdition = UserDefaults.standard.bool(forKey: K.Settings.allowEditionKey)
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
    
    @IBAction func segueToEdit(_ sender: Any) {
        guard allowEdition else {
            let title = "Modo de edición desactivado"
            let message = "Para activar el modo de edición ve a tu perfil."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        
        if let player = audioPlayer {
            if reproducing {
                playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                player.stop()
            }
        }
        
        performSegue(withIdentifier: segueToEditEvent, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToEditEvent {
            let ve = segue.destination as! EditEventViewController
            ve.event = event
            ve.delegate = self
            ve.delegateReload = delegateReload
        }
    }
    
    // Play song
    @IBAction func playMusic(_ sender: UIButton) {
        print("playMusic")
        if self.event.element.song?.assetURL != nil {
            audioPlayer = try? AVAudioPlayer(contentsOf: self.event.element.song!.assetURL!)
            //Detect song ending
            audioPlayer.numberOfLoops = 0
            audioPlayer.delegate = self
            
            if audioPlayer != nil {
                audioPlayer.prepareToPlay()
            } else {
                print("No se encontró la canción.")
            }
            reproducing = !reproducing
            
            if let player = audioPlayer {
                if reproducing {
                    playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
                    audioPlayer.play()
                } else {
                    playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                    player.stop()
                }
            }
        }
    }
    
}

