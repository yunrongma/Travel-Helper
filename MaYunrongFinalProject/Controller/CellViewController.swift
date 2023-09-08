//
//  CellViewController.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/11/23.
//

import UIKit

class CellViewController: UIViewController {

    var despContent:String?

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     	   descriptionLabel.text = despContent

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
