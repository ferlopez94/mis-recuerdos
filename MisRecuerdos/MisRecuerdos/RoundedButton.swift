//
//  RoundedButton.swift
//  EVA Health
//
//  Created by fernandolopezmartinez on 22/10/17.
//  Copyright © 2017 Higia Inc. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    // MARK: - Instance variables
    
    @IBInspectable var titleColorNormal: UIColor = UIColor.black {
        didSet {
            setTitleColor(titleColorNormal, for: .normal)
        }
    }
    
    @IBInspectable var titleColorHighlighted: UIColor = UIColor.white {
        didSet {
            setTitleColor(titleColorHighlighted, for: .highlighted)
        }
    }
    
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
    
    @IBInspectable var borderColorForHighlighted: UIColor = UIColor.black
    @IBInspectable var backgroundColorForHighlighted: UIColor = UIColor.black
    
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case false:
                layer.borderColor = borderColorForNormal.cgColor
                backgroundColor = backgroundColorForNormal
            case true:
                layer.borderColor = borderColorForHighlighted.cgColor
                backgroundColor = backgroundColorForHighlighted
            }
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
        titleLabel?.font = UIFont(name: "Century Gothic", size: 24.0)
        layer.borderColor = borderColorForNormal.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        
        setTitleColor(titleColorNormal, for: .normal)
        setTitleColor(titleColorHighlighted, for: .highlighted)
    }
    
}
