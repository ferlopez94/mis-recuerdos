//
//  ShowProfileViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 30/10/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class ShowProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

    
    // MARK: - View Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let data = UserDefaults.standard.data(forKey: K.Accounts.actualUserKey),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User else {
                return
        }
        
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.image = user.photo
        nameLabel.text = user.name
        lastNameLabel.text = user.lastName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = formatter.date(from: user.dateOfBirth)!
        formatter.dateStyle = .long
        dobLabel.text = formatter.string(from: date)
        commentsLabel.text = user.comments == "" ? "No tienes comentarios acerca de ti." : user.comments
        
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
