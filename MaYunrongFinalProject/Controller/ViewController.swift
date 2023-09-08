//
//  ViewController.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 3/30/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Photos


class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var loginFilePath: URL?
    
    private var userJson = [LoginUser]()
    
    var User = UserModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        PHPhotoLibrary.requestAuthorization() { (status) in
            if(status == .authorized)
            {
                print("Photo access permitted!")
            }
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        loginFilePath = URL(string: "\(documentsDirectory)/usersArray.json")!
    }
    
    // synchronize with firestore database
    @IBAction func signUpDidTapped(_ sender: UIButton) {
        // https://firebase.google.com/docs/firestore/security/get-started#auth-required
        // allow read, write: if request.auth != null;
        
        User.email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().createUser(withEmail: User.email, password: password) {
            authResult, error in

            if (error != nil) {
                print(error!)
            }

            else {
                self.User.uid = authResult!.user.uid
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: [
                    "email": self.User.email,
                    "uid": self.User.uid
                ]) { (error) in
                    if error != nil {
                        print(error!)
                    }
                }
            }
//            print("the created user has an id of \(authResult?.user.uid ?? "nil")")
            // passwordTextField -> secure text entry

        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
        load()
        if checkUser(email: emailTextField.text!,password: passwordTextField.text!) == true {
            performSegue(withIdentifier: "loginedSegue", sender: Any?.self)
        }
    }
    
    // data persistence: save registered users in local json
    func load() {
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: loginFilePath!)
            let decodedUsers = try decoder.decode(Array<LoginUser>.self, from: data)

            userJson = decodedUsers
        } catch {
            userJson = [LoginUser]()
            print("user load failed \(error)")
        }

    }
    
    func checkUser(email: String,password: String) -> Bool{
//        var flg = 0
        for index in 0 ..< userJson.count {
            if(userJson[index].email == email && userJson[index].password == password)
            {
                return true
            }
        }
        return false
    }
}

