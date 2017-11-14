//
//  EventsGalleryViewController.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSPhotoGallery
import UIKit

protocol EventsGalleryDelegate {
    func showEventDetails(atIndex index: Int)
}

class EventsGalleryViewController: UIViewController, EventsGalleryDelegate, UpdateEvent {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Instance variables
    
    var events = [(offset: Int, element: Event)]()
    var photos = [INSPhotoViewable]()
    let numberOfItems: CGFloat = 2
    let showEventDetailsSegueIdentifier = "showEventDetails"
    var eventToShowIndex = 0
    var delegate: ReloadDataE?
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for event in events {
            let title = "\(event.offset)"
            let photo = INSPhoto(image: event.element.photo, thumbnailImage: event.element.photo)
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
    
    func showEventDetails(atIndex index: Int) {
        eventToShowIndex = index
        performSegue(withIdentifier: showEventDetailsSegueIdentifier, sender: nil)
    }
    
    
    // MARK: - UpdateContact methods
    
    func update(event: (offset: Int, element: Event)) {
        self.events[eventToShowIndex] = event
        collectionView.reloadData()
        delegate?.reloadData(shouldReload: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showEventDetailsSegueIdentifier {
            let ve = segue.destination as! ShowEventViewController
            ve.event = events[eventToShowIndex]
            ve.delegate = self
        }
    }
    
}

extension EventsGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionViewCell
        
        cell.populateWithPhoto(photos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EventCollectionViewCell
        let currentPhoto = photos[indexPath.row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        
        let eventOverlayView = EventOverlayView(frame: CGRect.zero)
        eventOverlayView.index = indexPath.row
        eventOverlayView.delegate = self
        
        galleryPreview.overlayView = eventOverlayView
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell
            }
            return nil
        }
        
        galleryPreview.navigateToPhotoHandler = { photo in
            eventOverlayView.index = Int((photo.attributedTitle?.string)!) ?? 0
        }
        
        present(galleryPreview, animated: true, completion: nil)
    }
    
}
