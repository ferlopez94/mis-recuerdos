//
//  ContactsGalleryViewController.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 04/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

protocol ContactsGalleryDelegate {
    func showContactDetails(atIndex index: Int)
}

class ContactsGalleryViewController: UIViewController, ContactsGalleryDelegate, UpdateContact {

    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Instance variables
    
    var contacts = [(offset: Int, element: Contact)]()
    var photos = [INSPhotoViewable]()
    let numberOfItems: CGFloat = 2
    let showContactDetailsSegueIdentifier = "showContactDetails"
    var contactToShowIndex = 0
    var delegate: ReloadData?
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        for contact in contacts {
            let title = "\(contact.offset)"
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
    
    func showContactDetails(atIndex index: Int) {
        contactToShowIndex = index
        performSegue(withIdentifier: showContactDetailsSegueIdentifier, sender: nil)
    }
    
    
    // MARK: - UpdateContact methods
    
    func update(contact: (offset: Int, element: Contact)) {
        self.contacts[contactToShowIndex] = contact
        collectionView.reloadData()
        delegate?.reloadData(shouldReload: true)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showContactDetailsSegueIdentifier {
            let vc = segue.destination as! ShowContactViewController
            vc.contact = contacts[contactToShowIndex]
            vc.delegate = self
        }
    }

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
        
        let contactOverlayView = ContactOverlayView(frame: CGRect.zero)
        contactOverlayView.index = indexPath.row
        contactOverlayView.delegate = self
        
        galleryPreview.overlayView = contactOverlayView
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell
            }
            return nil
        }
        
        galleryPreview.navigateToPhotoHandler = { photo in
            contactOverlayView.index = Int((photo.attributedTitle?.string)!) ?? 0
        }
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
}
