//
//  LoginViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Instance properties
    
    var users = [Users]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = User.loadFromFile()
    }
    

    // MARK: - Navigation
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
}
