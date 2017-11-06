//
//  ContactsViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var familyPhoto: UIImageView!
    @IBOutlet weak var knownPhoto: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Instance variables
    
    var user: User? = nil
    var filteredContacts = [(offset: Int, element: Contact)]()
    var familyContacts = [(offset: Int, element: Contact)]()
    var knownContacts = [(offset: Int, element: Contact)]()
    
    let segueToShowAll = "segueToShowAll"
    let segueToShowAllPhotos = "segueToShowAllPhotos"
    let segueToShowFamily = "segueToShowFamily"
    let segueToShowKnown = "segueToShowKnown"
    let segueToFiltered = "segueToFiltered"
    
    var timer = Timer()
    var imageIndex = 0
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        
        guard let user = self.user,
            let text = searchBar.text,
            text != "" else { return }
        
        filteredContacts = user.contacts.enumerated().filter { contact in
            if contact.element.name.lowercased().range(of: text.lowercased()) != nil {
                return true
            }
            
            let category = contact.element.category == .family ? "Familiar" : "Conocido"
            
            if category.lowercased().range(of: text.lowercased()) != nil {
                return true
            }
            
            return false
        }
        
        hideKeyboard()
        performSegue(withIdentifier: segueToFiltered, sender: nil)
    }
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
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
        switch segue.identifier! {
        case segueToShowAll:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = user!.contacts.enumerated().filter { _,_ in true }
        case segueToShowFamily:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = familyContacts
            vc.category = .family
        case segueToShowKnown:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = knownContacts
            vc.category = .known
        case segueToShowAllPhotos:
            let vc = segue.destination as! ContactsGalleryViewController
            vc.contacts = user!.contacts.enumerated().filter { _,_ in true }
        case segueToFiltered:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = filteredContacts
            vc.filtered = true
        default:
            break
        }
    }

}
