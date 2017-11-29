//
//  GameQuestionsViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/16/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import AVFoundation


class GameQuestionsViewController: UIViewController {
    @IBOutlet var Buttons: [RoundedButton]!
    @IBOutlet weak var imvPhoto: UIImageView!
    
    @IBOutlet weak var lnNumQ: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!

    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var btNext: RoundedButton!
    @IBOutlet weak var imgCorrect: UIImageView!
    @IBOutlet weak var bt1: RoundedButton!
    @IBOutlet weak var bt2: RoundedButton!
    @IBOutlet weak var bt3: RoundedButton!
    @IBOutlet weak var bt4: RoundedButton!
    
    var Questions: [Question]!
    var countQ = Int()
    var questionN = 0
    var answerV = Int()
    var totalPoints = 0
    var firstTry = true
    var player : AVAudioPlayer = AVAudioPlayer()
    var sound: Int = 0
    
    let unwindToMenuGameWithSegue = "unwindToMenuGameWithSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbAnswer.text = ""
        imgCorrect.alpha = 0
        PickQuestion()
        print(sound)
        self.title = ""
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Terminar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackMenuGame))
        navigationItem.rightBarButtonItem = rightButton
        self.bt1.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bt2.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bt3.titleLabel?.adjustsFontSizeToFitWidth = true
        self.bt4.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    //Method that changes the color of the buttons
    func changeColor(color: String) {
        if color == "azul" {
            for i in 0..<Buttons.count {
                Buttons[i].backgroundColor = UIColor(red: 74/255, green: 215/255, blue: 255/255, alpha: 0.4)
            }
        }
    }
    
    func PickQuestion() {
        print("funcion escoger pregunta")
       
        if countQ < Questions.count {
            firstTry = true
            btNext.alpha = 0
            btNext.isEnabled = false
            changeColor(color: "azul")
            resetButtons(activar: true)
            
            lnNumQ.text = "PREGUNTA " + String(countQ + 1)
            print("Numero de pregunta \(countQ)")
            answerV = Questions[countQ].answer
            
        
            let questionType = Questions[countQ].questionType
            
            if questionType == "Contacto" {
                lbQuestion.text = "¿Quién es esta persona?"
            }
            else if questionType == "Categoria" {
                lbQuestion.text = "¿Qué relación tienes con esta persona?"
            }
            else {
                lbQuestion.text = "¿Cuál fue este momento?"
            }
            
            imvPhoto.image = Questions[countQ].photo
            
            for i in 0..<Buttons.count {
                Buttons[i].setTitle(Questions[countQ].answersList[i], for: .normal)
            }
            countQ += 1
        }
    }
    
    //Function to set the answers in the buttons
    @IBAction func setAnswers(_ sender: UIButton) {
        
        if sender.tag == answerV {
            if sound == 1 {
                lbAnswer.alpha = 0
                imgCorrect.alpha = 1
            
            do{
                let audioPath = Bundle.main.path(forResource: "Correct Answer 3 Sound Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
            }
            catch{
                
            }
            player.play()
            }
            if sound == 2 {
                lbAnswer.alpha = 0
                imgCorrect.alpha = 1
                do{
                    let audioPath = Bundle.main.path(forResource: "Apple Pay Success Sound Effect", ofType: "wav")
                    try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
                }
                catch{
                    
                }
                player.play()
            }
        if sound == 3 {
            lbAnswer.textColor = UIColor.green
            lbAnswer.alpha = 0
            imgCorrect.alpha = 1
            do{
                let audioPath = Bundle.main.path(forResource: "Victory-Sound-Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
                }
            catch{
                    
                }
                player.play()
            }
           
        if firstTry == true {
                // Sumar 1 punto si fue el primer intento
                totalPoints += 1
            }
            // Mostrar boton para avanzar
            btNext.alpha = 1
            btNext.isEnabled = true
            resetButtons(activar: false)      // Desactivar Botones
            
        }
        else {
            firstTry = false
            lbAnswer.textColor = UIColor.red
            sender.isEnabled = false
            lbAnswer.alpha = 1
            lbAnswer.text = "Respuesta incorrecta"
            imgCorrect.alpha = 0
        }
    }

    @IBAction func nextQuestion(_ sender: UIButton) {
        lbAnswer.text = ""
        imgCorrect.alpha = 0
        btNext.alpha = 0
        btNext.isEnabled = false
        
        if countQ >= Questions.count {
            performSegue(withIdentifier: "showResults", sender: self)
        }
        PickQuestion()
    }
    
    func resetButtons(activar: Bool) {
        for i in 0..<Buttons.count {
            Buttons[i].isEnabled = activar
        }
    }
    
    func goBackMenuGame() {
        performSegue(withIdentifier: unwindToMenuGameWithSegue, sender: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            let vc = segue.destination as! ResultsViewController
            vc.score = totalPoints
        }
    }

}
