//
//  RoundedView.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 09/10/23.
//

import Foundation
import UIKit

@IBDesignable class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth =  newValue }
    }
    
    @IBInspectable var backgroundColorAlpha: CGFloat = 1.0 {
        didSet {
            self.updateBackgroundColorOpacity()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.updateBorderColor()
        }
    }
    
    @IBInspectable var addShadow: Bool = false {
        didSet {
            self.updateShadow()
        }
    }
    @IBInspectable var shadowOffsetX: CGFloat = 0 {
        didSet {
            self.updateCustomShadow()
        }
    }
    @IBInspectable var shadowOffsetY: CGFloat = 0 {
        didSet {
            self.updateCustomShadow()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.updateCustomShadow()
        }
    }
    @IBInspectable var shadowColor: UIColor = .white {
        didSet {
            self.updateCustomShadow()
        }
    }
    @IBInspectable var shadowColorOpacity: CGFloat = 1 {
        didSet {
            self.updateCustomShadow()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            self.updateCustomShadow()
        }
    }
}

extension RoundedView {
    fileprivate func updateBorderColor() {
        self.layer.borderColor = borderColor.cgColor
    }
    fileprivate func updateBackgroundColorOpacity(){
        let bgc = self.backgroundColor
        self.backgroundColor = bgc?.withAlphaComponent(backgroundColorAlpha)
    }
    fileprivate func updateShadow() {
        self.addShadow()
    }
    fileprivate func updateCustomShadow() {
        self.addShadow(x: shadowOffsetX, y: shadowOffsetY, radius: shadowRadius, color: shadowColor, opacity: shadowOpacity, colorAlpha: shadowColorOpacity)
    }
}
