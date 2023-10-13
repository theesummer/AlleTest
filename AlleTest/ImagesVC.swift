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
    var imageURLs: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCVCell")
        self.view.startLoadingWithText("Fetching images")
        self.fetchImages()
    }
}

extension ImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PhotoCVCell.updateCellFor(collectionView: self.collectionView, indexPath: indexPath, imageURL: self.imageURLs[indexPath.item], contentMode: .scaleAspectFill, selectedIndex: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 1, height: collectionView.frame.width/4 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotosViewerVC") as! PhotosViewerVC
        controller.imageURLs = self.imageURLs
        controller.selectedIndex = indexPath
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCVCell else {return}
////        cell.imageView.image = nil
//        collectionView.reloadData()
//    }
}

extension ImagesVC {
    fileprivate func importImages() {
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
                        guard let data = image?.jpegData(compressionQuality: 1) else {return}
                        print("SKImageName: ", fetchResult[i].originalFilename)
                        let filename = fetchResult[i].originalFilename.components(separatedBy: ".").first ?? "image"
                        SKFileManager.shared.write(image: data, name: filename, fileType: .heic, directory: .images)
                    })
                }
                self.fetchImages()
            } else {
                print("Unable to fetch photos")
                DispatchQueue.main.async {
                    self.view.stopBasicLoading()
                }
            }
        }
    }
    fileprivate func fetchImages() {
        guard let urls = SKFileManager.shared.getFilesFrom(directory: .images) else {
            self.importImages()
            return
        }
        if urls.count > 0 {
            self.imageURLs = urls
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.stopBasicLoading()
            }
        } else {
            self.importImages()
        }
        
    }
}
