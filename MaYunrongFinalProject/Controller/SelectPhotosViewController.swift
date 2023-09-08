//
//  SelectPhotosViewController.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/16/23.
//

import UIKit
import Photos
import PhotosUI

// Add a CollectionViewController scene to storyboard
// Set class identity to “SelectPhotosViewController”
// Set the prototype cell’s reuse identifier to “PhotoCell”

class SelectPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate
{
    private var images = [UIImage?]()
    private var identifiers = [String]()
    
    private var imagesModel = PhotosModel.sharedInstance
    
    var allPhotos: PHFetchResult<PHAsset>? = nil
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagesModel.load()
        
        // return a fetch result that contains the requested PHAsset objects (assets of all photos)
        self.allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        images = [UIImage?]()
        identifiers = self.imagesModel.getPhotosArray(tripId: self.imagesModel.currentTripId) // array of identifiers from imagesModel
        for identifier in identifiers
        {
            allPhotos?.enumerateObjects{ [self](object,_,_) in
                if identifier == object.localIdentifier
                {
                    let asset = object
                    let img = getUIImage(asset: asset)
                    images.append(img)
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    
    func getUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    // How many sections to display
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // For a given section, how many items to display
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("images count \(images.count)")
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // Dequeue reusable cell with “PhotoCell” identifier and typecast cell to CollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let cellWidth = (width - 50) / 2
        let cellHeight = (height - 30) / 3
        
        return .init(width: cellWidth, height: cellHeight)
        // click collection view -> set Estimate size to "None"
    }
    
    
    @IBAction func addDidTapped(_ sender: UIBarButtonItem) {
        // create a PHPickerConfiguration
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 10 // Set the maximum number of photos that can be selected to be 10
        config.filter = .images
        // create a new picker view controller with the configuration pickerConfig
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
    
        for result in results {
            let success: Bool = self.imagesModel.insertPhoto(imageIdentifier: result.assetIdentifier!)
            if(success == true)
            {
                self.allPhotos?.enumerateObjects{ [self](object,_,_) in
                    if result.assetIdentifier == object.localIdentifier
                    {
                        let img = getUIImage(asset: object)
                        images.append(img)
                    }
                }
            }
        }
        self.collectionView.reloadData()
    }

}

