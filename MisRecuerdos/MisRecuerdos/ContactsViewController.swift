//
//  ContactsViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var familyPhoto: UIImageView!
    @IBOutlet weak var knownPhoto: UIImageView!
    
    
    // MARK: - Instance variables
    
    var user: User? = nil
    var familyContacts = [(offset: Int, element: Contact)]()
    var knownContacts = [(offset: Int, element: Contact)]()
    
    let segueToShowAll = "segueToShowAll"
    let segueToShowFamily = "segueToShowFamily"
    let segueToShowKnown = "segueToShowKnown"
    
    var timer = Timer()
    var imageIndex = 0
    
    
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
        
        familyContacts = self.user!.contacts.enumerated().filter {$0.element.category == .family }
        knownContacts = self.user!.contacts.enumerated().filter {$0.element.category == .known }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageIndex = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeImages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func changeImages() {        
        if familyContacts.count > 0 {
            let contact = familyContacts[imageIndex % familyContacts.count].element
            familyPhoto.image = contact.photo
        }
        
        if knownContacts.count > 0 {
            let contact = knownContacts[imageIndex % knownContacts.count].element
            knownPhoto.image = contact.photo
        }
        
        imageIndex += 1
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToContacts(segue: UIStoryboardSegue) {}
    
    @IBAction func unwindToContactsAfterAddNewContact(segue: UIStoryboardSegue) {
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
        print(self.user!)
        print(self.user!.contacts)
        familyContacts = self.user!.contacts.enumerated().filter {$0.element.category == .family }
        knownContacts = self.user!.contacts.enumerated().filter {$0.element.category == .known }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToShowAll {
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = user!.contacts.enumerated().filter { _,_ in true }
            vc.category = nil
        } else if segue.identifier == segueToShowFamily {
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = familyContacts
            vc.category = .family
        } else if segue.identifier == segueToShowKnown {
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = knownContacts
            vc.category = .known
        }
    }

}
