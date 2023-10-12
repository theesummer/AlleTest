//
//  ImagesVC.swift
//  AlleTest
//
//  Created by Swaroop Kurra on 11/10/23.
//

import UIKit
import Photos

class ImagesVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCVCell")
        self.view.startLoadingWithText("Fetching images")
        self.fetchImages()
    }
}

extension ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PhotoCVCell.updateCellFor(collectionView: self.collectionView, indexPath: indexPath, image: self.images[indexPath.item], contentMode: .scaleAspectFill, selectedIndex: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 1, height: collectionView.frame.width/4 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotosViewerVC") as! PhotosViewerVC
        controller.images = self.images
        controller.selectedIndex = indexPath
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ImagesVC {
    fileprivate func fetchImages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imgageManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgageManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.images.append(image!)
                    })
                }
            } else {
                print("Unable to fetch photos")
                DispatchQueue.main.async {
                    self.view.stopBasicLoading()
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.stopBasicLoading()
            }
        }
    }
}
