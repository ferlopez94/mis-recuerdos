//
//  EventsTableViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, UpdateEvent {
    
    // MARK: - Instance variables
    
    var events = [(offset: Int, element: Event)]()
    var category: EventCategory?
    var filtered: Bool?
    var selectedIndex = 0
    var delegate: ReloadDataE?
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        if events.isEmpty {
            return 1
        }
        
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        
        guard !events.isEmpty else {
            if filtered != nil {
                cell.reset(withMessage: "No hay eventos con la palabra buscada")
            } else if category == .personal {
                cell.reset(withMessage: "No has agregado eventos personales")
            } else if category == .other {
                cell.reset(withMessage: "No has agregado otros eventos")
            } else {
                cell.reset()
            }
            
            return cell
        }
        
        let event = events[indexPath.row].element
        cell.update(with: event)
        return cell
    }
    
    
    // MARK: - UpdateContact methods
    
    func update(event: (offset: Int, element: Event)) {
        self.events[selectedIndex] = event
        tableView.reloadData()
        delegate?.reloadData(shouldReload: true)
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if events.isEmpty {
            return nil
        }
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = tableView.indexPathForSelectedRow!.row
        self.selectedIndex = index
        let event = events[index]
        let ve = segue.destination as! ShowEventViewController
        ve.event = event
        ve.delegate = self
        ve.delegateReload = delegate
    }
    
}
