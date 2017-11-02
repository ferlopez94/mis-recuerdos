//
//  RoundedView.swift
//  MisRecuerdos
//
//  Created by fernandolopezmartinez on 02/11/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    // MARK: - Instance variables
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColorForNormal: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = borderColorForNormal.cgColor
        }
    }
    
    @IBInspectable var backgroundColorForNormal: UIColor = UIColor.clear {
        didSet {
            backgroundColor = backgroundColorForNormal
        }
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    // MAKR: - Private methods
    
    private func setupButton() {
        layer.borderColor = borderColorForNormal.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }

}
