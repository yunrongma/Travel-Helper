//
//  TabBarController.swift
//  MaYunrongFinalProject
//
//  Created by Apple on 2023/4/15.
//

import UIKit

class TabBarController: UITabBarController {
    var despContent:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewControllers = viewControllers else{
            return
        }
        for viewController in viewControllers {
            if let cellNavigationControll = viewController as? CellNavigationController{
                if let cellViewController = cellNavigationControll.viewControllers.first as? CellViewController{
                    cellViewController.despContent = despContent
                }
            }
        }
        // Do any additional setup after loading the view.

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
