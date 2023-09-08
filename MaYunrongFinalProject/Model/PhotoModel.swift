//
//  PhotoModel.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/23/23.
//

import Foundation
import UIKit

class PhotosModel {
    // photo array
    private var photoJson = [Photo]()
    private var curIndex: Int = -1
    
    
    // singleton
    static let sharedInstance = PhotosModel()
    
    let imageFilePath: URL
    
    var currentTripId: Int = -1
    
    init() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        imageFilePath = URL(string: "\(documentsDirectory)/imagesArray.json")!

        print("\(imageFilePath)")
    }
    
    // number of photos
    func numberOfPhotos() -> Int {
        return photoJson[curIndex].identifiers.count
    }
    
     // Return mms at a given tripId
    func getPhotosArray(tripId: Int) -> [String] {

        var tripPhotos = [String]()
       
        for identifier in photoJson[curIndex].identifiers
        {
            tripPhotos.append(identifier)
        }
        
        return tripPhotos
    }
    
    
    func getPhoto(at index: Int) -> String? {
        if (index < numberOfPhotos() && index >= 0) {
            return photoJson[curIndex].identifiers[index]
        }
        return nil
    }
    
    // Insert
    func insertPhoto(imageIdentifier: String) -> Bool{
        var flg = 0
        for identifier in photoJson[curIndex].identifiers
        {
            if(identifier == imageIdentifier)
            {
                flg = 1
                break
            }
        }
        
        if(flg == 0)
        {
            photoJson[curIndex].identifiers.append(imageIdentifier)
            save()
            return true
        }
        
        else
        {
            return false
        }
    }
    
    // Write -> saving to disk
    func save() {
        // Codable API
        // 1. Data you want to save needs to conform to "Codable" Protocol
        // 2. Use a custom encoder to encode to file system

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(photoJson)
            
            let jsonString = String(data: data, encoding: .utf8)!

            try jsonString.write(to: imageFilePath, atomically: true, encoding: .utf8)
            

        } catch {
            print(error)
        }
    }

    // Read -> reading from disk
    func load() {
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: imageFilePath)
            let decodedImages = try decoder.decode(Array<Photo>.self, from: data)

            photoJson = decodedImages
            
            var flg = 0
            for index in 0 ..< photoJson.count {
                if(photoJson[index].tripId == currentTripId)
                {
                    curIndex = index
                    flg = 1
                    break
                }
            }
            if(flg == 0)
            {
                let photo = Photo()
                photo.tripId = currentTripId
                photo.identifiers = []
                curIndex = photoJson.count
                photoJson.append(photo)
                
                print("add new photo trip \(currentTripId)")
            }
            
        } catch {
            let photo = Photo()
            photo.tripId = currentTripId
            photo.identifiers = []
            curIndex = 0
            photoJson.append(photo)
            print("load error:\(error)")
        }

    }
}



