//
//  UserModel.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/29/23.
//

import Foundation

import Foundation
import Firebase

class UserModel: NSObject, Codable {
    var email: String
    var uid: String
    
    static let sharedInstance = UserModel()
    
    override init() {
        email = ""
        uid = Firestore.firestore().collection("users").document().documentID
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case uid
    }
}
