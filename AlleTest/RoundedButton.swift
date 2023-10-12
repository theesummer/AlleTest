//
//  RoundedButton.swift
//  LuxAi
//
//  Created by Swaroop Kurra on 02/12/21.
//

import Foundation
import UIKit

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth =  newValue }
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
}

extension RoundedButton {
    fileprivate func updateBorderColor() {
        self.layer.borderColor = borderColor.cgColor
    }
    fileprivate func updateShadow() {
        self.addShadow()
    }
}
