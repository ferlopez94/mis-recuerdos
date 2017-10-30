//
//  MenuViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 29/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
            return
        }
        
        print(user)
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
