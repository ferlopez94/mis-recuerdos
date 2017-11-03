//
//  ContactsViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    // MARK: - Instance variables
    
    var user: User? = nil
    let segueToShowAll = "segueToShowAll"

    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
        print(self.user!)
        print(self.user!.contacts)
    }
    
    
    @IBAction func unwindToContacts(segue: UIStoryboardSegue) {}
    
    @IBAction func unwindToContactsAfterAddNewContact(segue: UIStoryboardSegue) {
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
        print(self.user!)
        print(self.user!.contacts)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToShowAll {
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = user!.contacts
        }
        
    }

}
