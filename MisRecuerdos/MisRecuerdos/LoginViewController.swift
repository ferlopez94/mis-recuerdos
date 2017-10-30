//
//  LoginViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Instance properties
    
    var users = [User]()
    let segueToMenuIdentifier = "segueToMenu"

    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = User.loadFromFile()
        tableView.reloadData()
    }
    

    // MARK: - TableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return users.count == 0 ? 1 : users.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
        guard users.count > 0 else {
            cell.reset()
            return cell
        }
        
        let user = users[indexPath.row]
        cell.update(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if users.count == 0 {
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let message = "¿Quieres iniciar sesión con la cuenta de: \(user.name) \(user.lastName)?"
        let alertController = UIAlertController(title: "Confirmar", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Si", style: .default) { (alert) in
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: K.Accounts.actualUserKey)
            self.performSegue(withIdentifier: self.segueToMenuIdentifier, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
}
