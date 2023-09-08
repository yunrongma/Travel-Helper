//
//  RegisterViewContorller.swift
//  MaYunrongFinalProject
//
//  Created by Apple on 2023/4/29.
//

import Foundation
import UIKit

// user info saved in local json
struct LoginUser: Codable{
    var email: String
    var password: String
    
    init()
    {
        email = ""
        password = ""
    }
    init(email: String,password: String)
    {
        self.email = email
        self.password = password
    }
}

// Note: register first, after successfully registered, automatically back to the main page, and use the email and password you just registered to login
class RegisterViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var againText: UITextField!
    
    private var loginFilePath: URL?
    
    private var userJson = [LoginUser]()
    
    private var curIndex: Int = -1
    
    var onComplete: (() -> Void)?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        loginFilePath = URL(string: "\(documentsDirectory)/usersArray.json")!

        // Do any additional setup after loading the view.
    }
    
    func save() {
        // Codable API
        // 1. Data you want to save needs to conform to "Codable" Protocol
        // 2. Use a custom encoder to encode to file system
//        var flg = 0
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(userJson)
            
            let jsonString = String(data: data, encoding: .utf8)!
            

            try jsonString.write(to: loginFilePath!, atomically: true, encoding: .utf8)
            

        } catch {
            print(error)
        }
    }
    
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
    
    func searchUser(email: String) -> Bool{
//        var flg = 0
        for index in 0 ..< userJson.count {
            if(userJson[index].email == email)
            {
                return true
            }
        }
        return false
    }
    
    func registerUser(email: String,password: String)
    {
        let newUser = LoginUser(email: email, password: password)
        userJson.append(newUser)
    }
    
    func CloseRegister(okPress: UIAlertAction)
    {
        self.dismiss(animated: true, completion: onComplete)
    }
    
    
    @IBAction func registerButtonDidTapped(_ sender: UIButton) {
        var okFlg = 0;
        let str = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")
        if(emailText.text == "")
        {
            let alert = UIAlertController(title: "Warning!", message: " Email is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if(passwordText.text == "")
        {
            let alert = UIAlertController(title: "Warning!", message: " Password is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if(againText.text == "")
        {
            let alert = UIAlertController(title: "Warning!", message: "Confirmation password is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if emailText.text?.contains("@") == false {
            let alert = UIAlertController(title: "Warning!", message: "The email address is badly formatted", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if(str.isSuperset(of: CharacterSet(charactersIn: passwordText.text!)) == false){
            let alert = UIAlertController(title: "Warning!", message: "The password is badly formatted", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if(passwordText.text != againText.text)
        {
            let alert = UIAlertController(title: "Warning!", message: "The password and confirmation password are different!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        else if(passwordText.text!.count < 4)
        {
            let alert = UIAlertController(title: "Warning!", message: "Password should be 4 or more characters in length!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok",style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            okFlg = 1;
        }
        
        if(okFlg == 0)
        {
            load()
            if(searchUser(email: emailText.text!) == false)
            {
                registerUser(email: emailText.text!, password: passwordText.text!)
                save()
            }
            
            emailText.text = ""
            passwordText.text = ""
            againText.text = ""
            
            let alert = UIAlertController(title: "Congratulations!", message: "You have Registered successfully!", preferredStyle: .alert)
         //   let okAction = UIAlertAction(title: "ok",style: .default,handler: CloseRegister)
       //     alert.addAction(okAction)
            self.present(alert, animated: true,completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
                // "Present Modally" Segue needs to dismiss VC
                self.dismiss(animated: true, completion: self.onComplete)
            }
        }
    }
    
   
    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: self.onComplete)
        
    }
    
    
    // Clicking “Next” should assign the keyboard to the UITextField and “Done” should dismiss the keyboard
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            if textView == friendsTextView {
//                descriptionTextView.becomeFirstResponder()
//            }
//            else if textView == descriptionTextView {
//                descriptionTextView.resignFirstResponder()
//            }
//            return false
//        }
//        return true
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

