//
//  AddEventViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/9/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import MediaPlayer //M
import AVFoundation //M

class AddEventViewController: SignupViewController, UIPickerViewDataSource, UIPickerViewDelegate, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var relationTextField: UITextField!
    @IBOutlet weak var playButton: UIButton! //M
    @IBOutlet weak var addButton: UIButton! //M
    @IBOutlet weak var songLabel: UILabel! //M
    @IBOutlet weak var artistLabel: UILabel! //M
    
    
    // MARK: - Instance variables
    
    var user: User? = nil
    override var commentsPlaceholder: String {
        get {
            return "Comentarios acerca del evento..."
        }
        set {
            
        }
    }
    
    var mediaPicker: MPMediaPickerController? //M
    var musicPlayer: MPMusicPlayerController? //M
    var songURL: URL! = nil //M
    var audioPlayer: AVAudioPlayer! //M
    var reproducing = false //M
    var change = false //M
    var songMedia: MPMediaItem! = nil //M
    
    let categoryOptions = ["Personal", "Otro"]
    let categoryPickerView = UIPickerView()
    
    let segueAfterAddIdentifier = "unwindToEventsAfterAddNewEvent"
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPickerView.delegate = self
        lastNameTextField.inputView = categoryPickerView
        
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
    }
    
    // Add new event
    override func createUser() {
        print("Add event")
        var message = ""
        let title = "Error"
        var alertController: UIAlertController
        
        guard user != nil else {
            message = "No puede agregar un evento en este momento."
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard photoImage != nil else {
            message = "Debes de seleccionar una foto para el evento."
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        guard nameTextField.text != "",
            let name = nameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir el nombre del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard dobTextField.text != "",
            let descript = dobTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir la descripción del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        guard lastNameTextField.text != "",
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else {
                message = "Debes de introducir la categoría del evento."
                alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
        }
        
        let category = lastName == "Personal" ? EventCategory.personal : EventCategory.other
        let comments = commentsTextView.text == commentsPlaceholder ? "" : commentsTextView.text!
        let relative = relationTextField.text!
        
        print(name)
        print(descript)
        print(lastName)
        print(comments)
        
        let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
        let event = Event(name: name, descript: descript, category: category, relative: relative, comments: comments, song: songMedia, photo: photoImage!)
        
        user!.addEvent(event)
        
        if User.saveToFile(user!, replaceAtIndex: index) {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user!), forKey: K.Accounts.actualUserKey)
            performSegue(withIdentifier: segueAfterAddIdentifier, sender: nil)
        } else {
            message = "No se puede agregar eventos en este momento."
            alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // Cancel add new event
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Add music
    @IBAction func addMusic(_ sender: UIButton) {
        print("addMusic")
        if let player = audioPlayer {
            if change {
                playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                player.stop()
            }
        }
        change = true
        displayMediaPickerAndPlayItem()
    }
    
    // Play song
    @IBAction func playMusic(_ sender: UIButton) {
        print("playMusic")
        if songURL != nil {
            audioPlayer = try? AVAudioPlayer(contentsOf: songURL!)
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
                    playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                    audioPlayer.play()
                } else {
                    playButton.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
                    player.stop()
                }
            }
        }
    }
    
    
    // MARK: - UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == categoryPickerView {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView && component == 0 {
            return categoryOptions.count
        }
        return 0
    }
    
    
    // MARK: - UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return categoryOptions[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView && component == 0 {
            lastNameTextField.text = categoryOptions[row]
        }
    }
    
    override func textFieldEditingDidBegin(_ sender: UITextField) {}
    
    
    // MARK: - Music methods
    
    func displayMediaPickerAndPlayItem() {
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Get song information
        let representativeItem = mediaItemCollection.representativeItem
        
        if representativeItem?.assetURL != nil {
            songMedia = representativeItem
            let title = representativeItem?.title
            let artist = representativeItem?.artist
            
            // Get song URL
            songURL = (representativeItem?.assetURL)!
            songLabel.text = title
            artistLabel.text = artist
            self.dismiss(animated: true)
        }
    }
    
}
