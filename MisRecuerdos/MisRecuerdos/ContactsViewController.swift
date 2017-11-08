//
//  ContactsViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

protocol ReloadData {
    var shouldReload: Bool {get set}
    
    func reloadData(shouldReload: Bool)
}

class ContactsViewController: UIViewController, UISearchBarDelegate, ReloadData {
    
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
    var shouldReload = true
    
    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.delegate = self
        
        guard shouldReload else { return }
        shouldReload = false
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    
    // MARK: - ReloadData methods
    
    func reloadData(shouldReload: Bool) {
        self.shouldReload = shouldReload
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
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueToShowAll:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = user!.contacts.enumerated().filter { _,_ in true }
            vc.delegate = self
        case segueToShowFamily:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = familyContacts
            vc.category = .family
            vc.delegate = self
        case segueToShowKnown:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = knownContacts
            vc.category = .known
            vc.delegate = self
        case segueToShowAllPhotos:
            let vc = segue.destination as! ContactsGalleryViewController
            vc.contacts = user!.contacts.enumerated().filter { _,_ in true }
            vc.delegate = self
        case segueToFiltered:
            let vc = segue.destination as! ContactsTableViewController
            vc.contacts = filteredContacts
            vc.filtered = true
            vc.delegate = self
        default:
            break
        }
    }

}
