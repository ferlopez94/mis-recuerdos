//
//  ContactsGalleryViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 04/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

class ContactsGalleryViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Instance variables
    
    var contacts = [(offset: Int, element: Contact)]()
    var photos = [INSPhotoViewable]()
    let numberOfItems: CGFloat = 2
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        for contact in contacts {
            let title = "Nombre: \(contact.element.name)\nRelación: \(contact.element.category == .family ? "Familiar" : "Conocido")"
            let photo = INSPhoto(image: contact.element.photo, thumbnailImage: contact.element.photo)
            photo.attributedTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.white])
            photos.append(photo)
        }
        
        // Adjust CollectionView layout
        let itemSize = UIScreen.main.bounds.width / numberOfItems - numberOfItems
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = numberOfItems
        layout.minimumLineSpacing = numberOfItems
        collectionView.collectionViewLayout = layout
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

extension ContactsGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContactCollectionViewCell
        
        cell.populateWithPhoto(photos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ContactCollectionViewCell
        let currentPhoto = photos[indexPath.row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        
        galleryPreview.overlayView = ContactOverlayView(frame: CGRect.zero)
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell
            }
            return nil
        }
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
}
