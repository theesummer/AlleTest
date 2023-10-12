//
//  UIViewExtension.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 09/10/23.
//

import UIKit
extension UIView {
    public func addShadow() {
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
        updateShadowPath()
    }
    public func addShadow(x: CGFloat, y: CGFloat, radius: CGFloat, color: UIColor, opacity: Float, colorAlpha: CGFloat) {
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.withAlphaComponent(colorAlpha).cgColor
        self.layer.position = self.center
        updateShadowPath()
    }
    
    public func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    public func startLoadingWithText(_ message: String) {
        self.startBasicLoading(UIActivityIndicatorView.Style.large, alpha: 1, message: message, fontSize: 12, backgroundColor: UIColor.white)
    }
    public func startBasicLoading(_ indicatorStyle: UIActivityIndicatorView.Style, alpha:CGFloat, message: String, fontSize: CGFloat, backgroundColor: UIColor){
        
        DispatchQueue.main.async(execute: {
            self.stopBasicLoading()
            
            let loadingView = UIView(frame: self.bounds)
            
            if let _ = self as? UIImageView {
                
            } else {
                loadingView.backgroundColor = backgroundColor.withAlphaComponent(alpha)
            }
            loadingView.tag = 9999
            
            let indicator = UIActivityIndicatorView(style: indicatorStyle)
            indicator.color = .lightGray
            indicator.center = loadingView.center
            indicator.startAnimating()
            
            loadingView.addSubview(indicator)
            
            if message.utf16.count > 0 {
                let label = UILabel(frame: CGRect(x: 15, y: indicator.frame.origin.y + 60, width: loadingView.frame.size.width - 30, height: 50))
                label.numberOfLines = 2
                label.textAlignment = NSTextAlignment.center
                label.text = message
                label.textColor = .black
                loadingView.addSubview(label)
            }
//            loadingView.layer.zPosition = 88
            if(!self.isLoading){
                self.addSubview(loadingView)
            }
        })
    }
    public var isLoading: Bool{
        get{
            for view in self.subviews {
                if view.tag == 9999{
                    return true
                }
            }
            return false
        }
    }
    public func stopBasicLoading(){
        
        var foundView:UIView?
        for view in self.subviews {
            if view.tag == 9999 {
                foundView = view
            }
        }
        if let view = foundView{
            DispatchQueue.main.async(execute: {
                view.removeFromSuperview()
            })
        }
        
    }
}

extension UIView {
    public func addDismissGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}
