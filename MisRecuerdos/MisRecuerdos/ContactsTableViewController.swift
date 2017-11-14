//
//  ContactsTableViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 03/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController, UpdateContact {

    // MARK: - Instance variables
    
    var contacts = [(offset: Int, element: Contact)]()
    var category: ContactCategory?
    var filtered: Bool?
    var selectedIndex = 0
    var delegate: ReloadData?
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        if contacts.isEmpty {
            return 1
        }
        
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        
        guard !contacts.isEmpty else {
            if filtered != nil {
                cell.reset(withMessage: "No hay personas con la palabras buscada")
            } else if category == .family {
                cell.reset(withMessage: "No has agregado familiares")
            } else if category == .known {
                cell.reset(withMessage: "No has agregado conocidos")
            } else {
                cell.reset()
            }
            
            return cell
        }
        
        let contact = contacts[indexPath.row].element
        cell.update(with: contact)
        return cell
    }

   
    // MARK: - UpdateContact methods
    
    func update(contact: (offset: Int, element: Contact)) {
        self.contacts[selectedIndex] = contact
        tableView.reloadData()
        delegate?.reloadData(shouldReload: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if contacts.isEmpty {
            return nil
        }
        
        return indexPath
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = tableView.indexPathForSelectedRow!.row
        self.selectedIndex = index
        let contact = contacts[index]
        let vc = segue.destination as! ShowContactViewController
        vc.contact = contact
        vc.delegate = self
    }

}
