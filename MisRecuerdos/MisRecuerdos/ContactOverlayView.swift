//
//  ContactOverlayView.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 04/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import INSNibLoading

import INSPhotoGallery
import UIKit

class ContactOverlayView: INSNibLoadedView {

    // MARK: - Instance variables
    
    weak var photosViewController: INSPhotosViewController?
    var index = 0
    var delegate: ContactsGalleryDelegate?
    
    // Pass the touches down to other views
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }
    
    @IBAction func detailsButtonTapped(_ sender: AnyObject) {
        delegate?.showContactDetails(atIndex: index)
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        photosViewController?.dismiss(animated: true, completion: nil)
    }

}

extension ContactOverlayView: INSPhotosOverlayViewable {
    
    func populateWithPhoto(_ photo: INSPhotoViewable) {}
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: { result in
                self.alpha = 1.0
                self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
    
}
