//
//  PhotoCVCell.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 12/10/23.
//

import UIKit

class PhotoCVCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension PhotoCVCell {
    class func updateCellFor(collectionView: UICollectionView, indexPath: IndexPath, image: UIImage, contentMode: ContentMode, selectedIndex: IndexPath?) -> PhotoCVCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCVCell", for: indexPath) as! PhotoCVCell
        cell.imageView.image = image
        cell.imageView.contentMode = contentMode
        cell.addBorder(cell: cell, indexPath: indexPath, selectedIndex: selectedIndex)
        return cell
    }
    private func addBorder(cell: PhotoCVCell, indexPath: IndexPath, selectedIndex: IndexPath?) {
        guard let selectedIndex = selectedIndex else {return}
        if indexPath == selectedIndex {
            cell.imageView.layer.borderColor = UIColor.blue.cgColor
            cell.imageView.layer.borderWidth = 2
        } else {
            cell.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
