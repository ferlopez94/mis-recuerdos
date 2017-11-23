//
//  GameConfigurationViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import AVFoundation

class GameConfigurationViewController: UIViewController {

    
    @IBOutlet weak var numQuestionsLabel: UILabel!
    @IBOutlet weak var scSong: UISegmentedControl!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    
    var tElements = 0
    var nQuestions = 4
    var counter = 4
    var numSound = 1
    var delegate: UpdateSettings!
    var user: User?
    var player : AVAudioPlayer = AVAudioPlayer()
    
    let unwindToMenuGameWithSegue = "unwindToMenuGameWithSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tElements)
        numQuestionsLabel.text = String(describing: user!.numQuestions)
        decrementButton.isEnabled = true
        counter = user!.numQuestions
        self.title = ""
    }
    
    
    //MARK: - Questions buttons actions
    
    @IBAction func decrementQuestions(_ sender: UIButton) {
        if counter == 4 {
            decrementButton.isEnabled = false
            let alert = UIAlertController(title: "Error", message: "El número mínimo de preguntas debe ser cuatro", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            counter -= 1
            numQuestionsLabel.text = "\(counter)"
            nQuestions = counter
            incrementButton.isEnabled = true
        }
    }
    
    @IBAction func incrementQuestions(_ sender: UIButton) {
        if counter < tElements {
            counter += 1
            numQuestionsLabel.text = "\(counter)"
            nQuestions = counter
            decrementButton.isEnabled = true
        }
        else {
            incrementButton.isEnabled = false
            let alert = UIAlertController(title: "Error", message: "Ya no puedes incrementar el número de preguntas porque no tienes suficientes contactos o eventos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Cancel
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func goBackMenuGame() {
        performSegue(withIdentifier: unwindToMenuGameWithSegue, sender: nil)
    }
    
    //Send changes
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewGame = segue.destination as! GameViewController
        if scSong.selectedSegmentIndex == 0 {
            viewGame.sound = numSound
        }
        else if scSong.selectedSegmentIndex == 1 {
            
            viewGame.sound = numSoundS
        }
        if scSong.selectedSegmentIndex == 2 {
            viewGame.sound = numSoundSS
        }
    }*/
    
    
    @IBAction func saveConfiguration(_ sender: UIButton) {
        delegate.update(numQuestions: nQuestions, sound: numSound)
        let user = self.user
        let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
        if User.saveToFile(user!, replaceAtIndex: index) {
            print("user saved!")
        }
    }
    
    @IBAction func selectSound(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            numSound = 1
            do{
                let audioPath = Bundle.main.path(forResource: "Correct Answer 3 Sound Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
            }
            catch{
                
            }
            player.play()
        }
        else if sender.selectedSegmentIndex == 1 {
            numSound = 2
            do{
                let audioPath = Bundle.main.path(forResource: "Apple Pay Success Sound Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
            }
            catch{
                
            }
            player.play()
        }
        else {
            numSound = 3
            do{
                let audioPath = Bundle.main.path(forResource: "Victory-Sound-Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
            }
            catch{
                
            }
            player.play()
        }
    }

}
