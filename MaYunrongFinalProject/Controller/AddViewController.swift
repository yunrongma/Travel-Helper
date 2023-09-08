//
//  AddViewController.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/6/23.
// Create a new file using the Cocoa Touch class template and make it a subclass of UIViewController.

import UIKit

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    //  yellow circle -> identity inspector -> Class name "AddViewController"
    // segue: ctrl+drag "Add" bar button in navigation bar of tableView to the AddViewController -> Present Modally
    // Library -> Navigation bar
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var tripsModel = TripsModel.sharedInstance
    
    var onComplete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false;

        // Do any additional setup after loading the view.
    }
    
    // add a flashcard to the model (use a singleton) and clear the text view and text field
    @IBAction func saveButtonDidTapped(_ sender: UIBarButtonItem) {
        // add alert controller when the same question was detected;
        // Touch return/done button on Alert displayed and inputs cleared
        let alert = UIAlertController(title: "Warning!", message: "The trip you have entered already exists, try a new trip", preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel
        )
        
        if (tripsModel.checkEnteredTrips(potentialDate: self.dateTextField.text!, potentialPlace: self.placeTextField.text!))
        {
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        
        else {
            tripsModel.insertTrip(place: placeTextField.text!, date: dateTextField.text!, description: descriptionTextView.text!, at: tripsModel.numberOfTrips())
            
            // "Present Modally" Segue needs to dismiss VC after entering valid flashcard
            self.dismiss(animated: true, completion: onComplete)
        }
        
        dateTextField.text = ""
        placeTextField.text = ""
        descriptionTextView.text = ""
    }
    
    
    // clear the text view and text field
    @IBAction func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        dateTextField.text = ""
        placeTextField.text = ""
        descriptionTextView.text = ""
        
        // "Present Modally" Segue needs to dismiss VC
        self.dismiss(animated: true, completion: onComplete)
    }
    
    // Touch background to dismiss keyboard
    @IBAction func backgroundButtonDidTapped(_ sender: UIButton) {
        dateTextField.resignFirstResponder()
        placeTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    // right click textView -> connect delegate to yellow circle
    func textViewDidChange(_ textView: UITextView) {
        enableOrDisableSaveButton()
    }
    
    // right click textField -> connect delegate to yellow circle
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableOrDisableSaveButton()
    }
    
    func enableOrDisableSaveButton() {
        // enable save button only if textView and textField are not empty
        if (!dateTextField.text!.isEmpty && !placeTextField.text!.isEmpty) {
            saveButton.isEnabled = true;
        }
        else {
            saveButton.isEnabled = false;
        }
    }
    
    // change the keyboard return key to “next” for UITextField
    // Clicking “Next” should assign the keyboard to from one UITextField to another
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == dateTextField) {
            placeTextField.becomeFirstResponder()
        }
        
        else if (textField == placeTextField) {
            descriptionTextView.becomeFirstResponder()
        }
        return true;
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
