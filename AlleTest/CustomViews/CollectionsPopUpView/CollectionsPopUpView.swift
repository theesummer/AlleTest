//
//  CollectionsPopUpView.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 09/10/23.
//

import UIKit

class CollectionsPopUpView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createStack: UIStackView!
    @IBOutlet weak var newTagView: RoundedView!
    @IBOutlet weak var newTagLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var alltags: [String] = ["Animal", "Rabbit", "Ipsum", "Lorem ipsum", "Lorem", "Lorem ipsum"]
    lazy var filteredTags: [String] = []
    lazy var selectedTags: [String]? = ["Animal", "Rabbit"]
    
    var vc: PhotosViewerVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let view = UINib(nibName: "CollectionsPopUpView", bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! UIView
        self.frame = self.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.textField.delegate = self
        addSubview(view)
        self.createStack.isHidden = true
        self.filteredTags = self.alltags
        self.collectionView.reloadData()
        collectionView.register(UINib(nibName: "TagCVCell", bundle: nil), forCellWithReuseIdentifier: "TagCVCell")
        self.addDismissGesture()
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideView))
        self.blurView.addGestureRecognizer(tap)
    }
    
    @IBAction func addNewTag(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else {return}
        self.alltags.append(text)
        self.filteredTags = self.alltags
        self.selectedTags?.append(text)
        self.textField.text = ""
        self.hideCreateTag(true)
        self.collectionView.reloadData()
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        self.hideView()
    }
    
    @objc private func hideView() {
        self.vc?.deregisterFromKeyboardNotifications()
        self.removeFromSuperview()
    }
}

extension CollectionsPopUpView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredTags.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return TagCVCell.updateCellFor(collectionView: self.collectionView, indexPath: indexPath, name: self.filteredTags[indexPath.item], selectedTags: self.selectedTags)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTags = selectedTags else {
            self.selectedTags?.append(self.filteredTags[indexPath.item])
            return
        }
        if selectedTags.contains(self.filteredTags[indexPath.item]) {
            self.selectedTags = selectedTags.filter {$0 != self.filteredTags[indexPath.item]}
        } else {
            self.selectedTags?.append(self.filteredTags[indexPath.item])
        }
        self.collectionView.reloadData()
    }
}

extension CollectionsPopUpView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, text.count > 0 else {
            self.filteredTags = self.alltags
            UIView.animate(withDuration: 0.5) {
                self.hideCreateTag(true)
            }
            self.collectionView.reloadData()
            return true
        }
        for tag in alltags {
            if !tag.lowercased().contains(text) {
                self.filteredTags = self.alltags.filter({ (result) -> Bool in
                    return result.range(of: text, options: .caseInsensitive) != nil
                })
                self.collectionView.reloadData()
            }
        }
        if self.filteredTags.count < 1 {
            UIView.animate(withDuration: 0.5) {
                self.hideCreateTag(false)
            }
            self.newTagLabel.text = text
        } else {
            self.hideCreateTag(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count > 0 else {
            self.filteredTags = self.alltags
            UIView.animate(withDuration: 0.5) {
                self.hideCreateTag(true)
            }
            self.collectionView.reloadData()
            return
        }
        if self.filteredTags.count < 1 {
            UIView.animate(withDuration: 0.5) {
                self.hideCreateTag(false)
            }
            self.newTagLabel.text = text
        } else {
            self.hideCreateTag(true)
        }
    }
    private func hideCreateTag( _ bool: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.createStack.isHidden = bool
            self.collectionView.isHidden = !bool
        }
    }
}
