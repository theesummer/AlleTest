//
//  PhotosViewerVC+Ext.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 12/10/23.
//

import UIKit

extension PhotosViewerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.tagsCV: return self.tags.count
        default: return self.images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.photosCV: return PhotoCVCell.updateCellFor(collectionView: self.photosCV, indexPath: indexPath, image: self.images[indexPath.item], contentMode: .scaleAspectFit, selectedIndex: nil)
        case self.photoIndexCV: return PhotoCVCell.updateCellFor(collectionView: self.photoIndexCV, indexPath: indexPath, image: self.images[indexPath.item], contentMode: .scaleAspectFill, selectedIndex: self.selectedIndex)
        case self.tagsCV: return TagCVCell.updateCellFor(collectionView: self.tagsCV, indexPath: indexPath, name: self.tags[indexPath.item])
        default: return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.tagsCV: return
        default:
            self.descriptionLabel.text = OCRManager().extractTextFrom(self.images[indexPath.item]) ?? "Contents Unavailable"
            self.imageView.image = self.images[indexPath.item]
            self.selectedIndex = indexPath
            self.photoIndexCV.reloadData()
//            self.photosCV.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.photoIndexCV:
            return CGSize(width: self.view.frame.width * 0.015, height: 40)
        case self.photosCV:
            return CGSize(width: self.photosCV.frame.width, height: self.photosCV.frame.height)
        default:
            return CGSize(width: 83, height: 32)
        }
    }
}

extension PhotosViewerVC {
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        let info = notification.userInfo!
        if let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.2) {
                    self.view.frame.origin.y -= (keyboardSize.height + 50)
                }
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
//            self.view.layoutIfNeeded()
        }
    }
}
