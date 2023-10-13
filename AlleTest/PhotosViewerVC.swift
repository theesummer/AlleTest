//
//  PhotosViewerVC.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 08/10/23.
//

import UIKit
import Photos

class PhotosViewerVC: UIViewController {
    enum TabItem {
        case share, info, delete
    }
    
    @IBOutlet weak var shareItem: UIImageView!
    @IBOutlet weak var infoItem: UIImageView!
    @IBOutlet weak var deleteItem: UIImageView!
    @IBOutlet weak var photosCV: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoIndexCV: UICollectionView!
    @IBOutlet weak var infoView: RoundedView!
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tagsCV: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMore: UILabel!
    @IBOutlet weak var editTags: UILabel!
    
    var imageURLs: [URL] = []
    var tags: [String] = ["Animal", "Rabbit"]
    var selectedIndex = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestures()
        self.photosCV.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCVCell")
        self.photoIndexCV.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCVCell")
        self.tagsCV.register(UINib(nibName: "TagCVCell", bundle: nil), forCellWithReuseIdentifier: "TagCVCell")
        photoIndexCV.reloadData()
        photoIndexCV.layoutIfNeeded()
        self.photoIndexCV.scrollToItem(at: self.selectedIndex, at: .left, animated: false)
        self.photoIndexCV.selectItem(at: self.selectedIndex, animated: true, scrollPosition: .left)
        self.view.addDismissGesture()
        if self.imageURLs.count > 0 {
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let data = try Data(contentsOf: self.imageURLs[self.selectedIndex.item])
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else {return}
                        self.imageView.image = image
                        self.descriptionLabel.text = OCRManager().extractTextFrom(image) ?? "Contents Unavailable"
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.hideInfoView()
    }
    private func addGestures() {
        let tapForMore = UITapGestureRecognizer(target: self, action: #selector(self.readMoreClicked))
        self.readMore.addGestureRecognizer(tapForMore)
        let edit = UITapGestureRecognizer(target: self, action: #selector(self.editTagsClicked))
        self.editTags.addGestureRecognizer(edit)
    }
    @objc fileprivate func readMoreClicked() {
        UIView.animate(withDuration: 0.5) {
            if self.readMore.text == "Collapse" {
                self.descriptionLabel.numberOfLines = 2
                self.readMore.text = "Read more"
            } else {
                self.descriptionLabel.numberOfLines = 0
                self.readMore.text = "Collapse"
            }
        }
    }
    @objc fileprivate func editTagsClicked() {
        let collectionsView = CollectionsPopUpView(frame: self.view.frame)
        collectionsView.vc = self
        self.view.addSubview(collectionsView)
        self.registerForKeyboardNotifications()
    }
    @IBAction func infoTabClicked(_ sender: Any) {
        self.setStatefor(tabItem: .info)
        self.showInfoView()
    }
    @IBAction func shareTabClicked(_ sender: Any) {
        self.setStatefor(tabItem: .share)
        self.hideInfoView()
    }
    @IBAction func deleteTabClicked(_ sender: Any) {
        self.setStatefor(tabItem: .delete)
        self.hideInfoView()
    }
    private func setStatefor(tabItem: TabItem) {
        switch tabItem {
        case .share:
            self.shareItem.tintColor = .black
            self.shareItem.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
            self.infoItem.tintColor = .darkGray
            self.infoItem.image = UIImage(systemName: "info.circle")
            self.deleteItem.tintColor = .darkGray
            self.deleteItem.image = UIImage(systemName: "trash.circle")
        case .info:
            self.shareItem.tintColor = .darkGray
            self.shareItem.image = UIImage(systemName: "square.and.arrow.up.circle")
            self.infoItem.tintColor = .black
            self.infoItem.image = UIImage(systemName: "info.circle.fill")
            self.deleteItem.tintColor = .darkGray
            self.deleteItem.image = UIImage(systemName: "trash.circle")
        case .delete:
            self.shareItem.tintColor = .darkGray
            self.shareItem.image = UIImage(systemName: "square.and.arrow.up.circle")
            self.infoItem.tintColor = .darkGray
            self.infoItem.image = UIImage(systemName: "info.circle")
            self.deleteItem.tintColor = .black
            self.deleteItem.image = UIImage(systemName: "trash.circle.fill")
        }
    }
    private func showInfoView() {
        UIView.animate(withDuration: 0.5) {
            self.infoViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    private func hideInfoView() {
        UIView.animate(withDuration: 0.5) {
            self.infoViewBottomConstraint.constant = -self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }
}

