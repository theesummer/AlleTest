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
    class func updateCellFor(collectionView: UICollectionView, indexPath: IndexPath, imageURL: URL, contentMode: ContentMode, selectedIndex: IndexPath?) -> PhotoCVCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCVCell", for: indexPath) as! PhotoCVCell
//        DispatchQueue.global(qos: .userInteractive).async {
//            do {
//                let data = try Data(contentsOf: imageURL.path)
//                DispatchQueue.main.async {
//                    cell.imageView.image = UIImage(data: data)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        do {
            cell.imageView.image = try UIGraphicsRenderer.renderImageAt(url: imageURL as NSURL, size: cell.imageView.frame.size, scale: 0.5)
        } catch {
            print(error)
        }
//        cell.imageView.image = UIImage(contentsOfFile: imageURL.path(percentEncoded: true))
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
