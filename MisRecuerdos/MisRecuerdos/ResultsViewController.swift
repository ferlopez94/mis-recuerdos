//
//  ResultsViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/17/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    let unwindToMenuGameWithSegue = "unwindToMenuGameWithSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Puntaje obtenido: \(score)"
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.title = ""
    }

    func goBackMenuGame() {
        performSegue(withIdentifier: unwindToMenuGameWithSegue, sender: nil)
    }

}
