//
//  EventCollectionViewCell.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/8/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit
import INSPhotoGallery

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Logic
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? INSPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
    }
}
