//
//  EventsViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

protocol ReloadDataE {
    var shouldReload: Bool {get set}
    
    func reloadData(shouldReload: Bool)
    func removeEvent(atIndex index: Int)
}

class EventsViewController: UIViewController, UISearchBarDelegate, ReloadDataE {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var personalPhoto: UIImageView!
    @IBOutlet weak var otherPhoto: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Instance variables
    
    var user: User? = nil
    var filteredEvents = [(offset: Int, element: Event)]()
    var personalEvents = [(offset: Int, element: Event)]()
    var otherEvents = [(offset: Int, element: Event)]()
    
    let segueToShowAll = "segueToShowAll"
    let segueToShowAllPhotos = "segueToShowAllPhotos"
    let segueToShowPersonal = "segueToShowPersonal"
    let segueToShowOther = "segueToShowOther"
    let segueToFiltered = "segueToFiltered"
    
    var timer = Timer()
    var imageIndex = 0
    var shouldReload = true
    var shouldRemove = false
    var shouldRemoveIndex = 0
    
    
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
        print(self.user!.events)
        
        personalEvents = self.user!.events.enumerated().filter {$0.element.category == .personal }
        otherEvents = self.user!.events.enumerated().filter {$0.element.category == .other }
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
        if personalEvents.count > 0 {
            let event = personalEvents[imageIndex % personalEvents.count].element
            personalPhoto.image = event.photo
        }
        
        if otherEvents.count > 0 {
            let event = otherEvents[imageIndex % otherEvents.count].element
            otherPhoto.image = event.photo
        }
        
        imageIndex += 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        
        guard let user = self.user,
            let text = searchBar.text,
            text != "" else { return }
        
        filteredEvents = user.events.enumerated().filter { event in
            if event.element.name.lowercased().range(of: text.lowercased()) != nil {
                return true
            }
            
            if event.element.relative.lowercased().range(of: text.lowercased()) != nil {
                return true
            }
            
            let category = event.element.category == .personal ? "Personal" : "Otro"
            
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
    
    func removeEvent(atIndex index: Int) {
        print("removeEvent")
        guard let _ = self.user else { return }
        shouldRemove = true
        shouldRemoveIndex = index
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToEvents(segue: UIStoryboardSegue) {}
    
    @IBAction func unwindToEventsAfterAddNewEvent(segue: UIStoryboardSegue) {
        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        self.user = user
        print(self.user!)
        print(self.user!.events)
        personalEvents = self.user!.events.enumerated().filter {$0.element.category == .personal }
        otherEvents = self.user!.events.enumerated().filter {$0.element.category == .other }
    }
    
    @IBAction func unwindToEventsAfterRemoved(segue: UIStoryboardSegue) {
        guard shouldRemove, let user = self.user else { return }
        
        shouldRemove = false
        user.removeEvent(atIndex: shouldRemoveIndex)
        
        let index = UserDefaults.standard.integer(forKey: K.Accounts.actualUserIndexKey)
        
        if User.saveToFile(user, replaceAtIndex: index) {
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: K.Accounts.actualUserKey)
            personalEvents = user.events.enumerated().filter {$0.element.category == .personal }
            otherEvents = user.events.enumerated().filter {$0.element.category == .other }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueToShowAll:
            let ve = segue.destination as! EventsTableViewController
            ve.events = user!.events.enumerated().filter { _,_ in true }
            ve.delegate = self
        case segueToShowPersonal:
            let ve = segue.destination as! EventsTableViewController
            ve.events = personalEvents
            ve.category = .personal
            ve.delegate = self
        case segueToShowOther:
            let ve = segue.destination as! EventsTableViewController
            ve.events = otherEvents
            ve.category = .other
            ve.delegate = self
        case segueToShowAllPhotos:
            let ve = segue.destination as! EventsGalleryViewController
            ve.events = user!.events.enumerated().filter { _,_ in true }
            ve.delegate = self
        case segueToFiltered:
            let ve = segue.destination as! EventsTableViewController
            ve.events = filteredEvents
            ve.filtered = true
            ve.delegate = self
        default:
            break
        }
    }
    
}

