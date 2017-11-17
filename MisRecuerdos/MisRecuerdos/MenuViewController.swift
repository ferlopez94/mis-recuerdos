//
//  MenuViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 29/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

protocol RootUser {
    func modifyUser(_ user: User)
}

class MenuViewController: UIViewController, RootUser {
    
    // MARK: - Instance variables
    
    var user: User?
    let segueToShowProfileIdentifier = "segueToShowProfile"

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
            return
        }
        
        self.user = user
        UserDefaults.standard.set(user.allowEdition, forKey: K.Settings.allowEditionKey)
        print(user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - RootUser methods
    
    func modifyUser(_ user: User) {
        self.user = user
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let user = self.user else { return }
        
        switch identifier {
        case segueToShowProfileIdentifier:
            let vc = segue.destination as! ShowProfileViewController
            vc.user = user
            vc.delegateRootUser = self
        default:
            break
        }
    }
    
}
