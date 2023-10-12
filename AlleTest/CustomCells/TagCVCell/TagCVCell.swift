//
//  TagCVCell.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 08/10/23.
//

import UIKit

class TagCVCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

extension TagCVCell {
    class func updateCellFor(collectionView: UICollectionView, indexPath: IndexPath, name: String, selectedTags: [String]?) -> TagCVCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCVCell", for: indexPath) as! TagCVCell
        cell.name.text = name
        cell.updateActionButton(name: name, selectedTags: selectedTags)
        return cell
    }
    private func updateActionButton(name: String, selectedTags: [String]?) {
        guard let selectedTags = selectedTags else {return}
        if selectedTags.contains(name) {
            self.actionButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            self.actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    class func updateCellFor(collectionView: UICollectionView, indexPath: IndexPath, name: String) -> TagCVCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCVCell", for: indexPath) as! TagCVCell
        cell.name.text = name
        if cell.actionButton != nil {
            cell.actionButton.removeFromSuperview()
        }
        return cell
    }
}
