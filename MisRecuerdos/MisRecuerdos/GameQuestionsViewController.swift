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
    
    var Questions: [Question]!
    var countQ = Int()
    var questionN = 0
    var answerV = Int()
    var totalPoints = 0
    var firstTry = true
    var player : AVAudioPlayer = AVAudioPlayer()
    var sound: Int = 0
    
    let unwindToMenuGameWithSegue = "unwindToMenuGameWithSegue"
    
    //var anterior: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        PickQuestion()
        print(sound)
        self.title = ""
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Terminar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackMenuGame))
        navigationItem.rightBarButtonItem = rightButton
        // Do any additional setup after loading the view.
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
            btNext.isHidden = true
            changeColor(color: "azul")
            resetButtons(activar: true)
            
            lnNumQ.text = "PREGUNTA NO. " + String(countQ + 1)
            print("Numero de pregunta \(countQ)")
            answerV = Questions[countQ].answer
            
        
            let questionType = Questions[countQ].questionType
            
            if questionType == "Contacto" {
                lbQuestion.text = "¿Quién es esta persona?"
            }
            
            imvPhoto.image = Questions[countQ].photo
            
            for i in 0..<Buttons.count {
                Buttons[i].setTitle(Questions[countQ].answersList[i], for: .normal)
                print(" Muestrate")
                
            }
            countQ += 1
        }
    }
    
    //Function to set the answers in the buttons
    @IBAction func setAnswers(_ sender: UIButton) {
        
        if sender.tag == answerV {
            if sound == 1 {
            lbAnswer.textColor = UIColor.green
            lbAnswer.text = "Respuesta Correcta"
            
            do{
                let audioPath = Bundle.main.path(forResource: "Correct Answer 3 Sound Effect", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
            }
            catch{
                
            }
            player.play()
            }
            if sound == 2 {
                lbAnswer.textColor = UIColor.green
                lbAnswer.text = "Respuesta Correcta"
                do{
                    let audioPath = Bundle.main.path(forResource: "Apple Pay Success Sound Effect", ofType: "mp3")
                    try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath : audioPath!)as URL)
                }
                catch{
                    
                }
                player.play()
            }
        if sound == 3 {
            lbAnswer.textColor = UIColor.green
            lbAnswer.text = "Respuesta Correcta"
            do{
                let audioPath = Bundle.main.path(forResource: "Correct Answer 3 Sound Effect", ofType: "mp3")
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
            btNext.isHidden = false        // Mostrar boton siguiente
            resetButtons(activar: false)      // Desactivar Botones
            
        }
        else {
            firstTry = false
            // Cambiar color del boton a rojo
            sender.backgroundColor = UIColor.red
            lbAnswer.textColor = UIColor.red
            //sender.isEnabled = false
            lbAnswer.text = "Respuesta incorrecta"
        }
    }

    @IBAction func nextQuestion(_ sender: UIButton) {
        lbAnswer.text = ""
        btNext.isHidden = true
        
        print("Pregunta :" + String(countQ))
        if countQ >= Questions.count {
            // Guardar resultado de Quiz
            //anterior.quizzesRealizados.append(resultadosQuiz(numeroAciertos: puntosTotales, numeroPreguntas: Preguntas.count, fechaRealizacion: Date(), presicionQuiz: Double(puntosTotales)/Double(Preguntas.count), quizTerminado: true))
            print("Resultados Guardados")
            // Pasar a pantalla de resultados
            //performSegue(withIdentifier: "mostrarResultados", sender: self)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
