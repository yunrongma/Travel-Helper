//
//  TableViewController.swift
//  MaYunrongFinalProject
//
//  Created by Yunrong Ma on 4/6/23.
//  Create a new file (Cocoa Touch class) and make it a subclass of UITableViewController

//  library -> add a TableViewController to the storyboard -> embed Navigation Controller
//  yellow circle -> identity inspector -> Class name "TableViewController"
//  set TableViewController as data source: right click tableView -> connect data source with yellow circle
//  library -> bar button item -> Edit, Add
//  Prototype cell -> attribute inspector -> style: Right Detail

import UIKit

class TableViewController: UITableViewController {
    
    private var tripsModel = TripsModel.sharedInstance
    
    var despContent:String?
    
//    var tripId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsModel.numberOfTrips()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // click prototype cell -> attribute inspector -> identifier -> TableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        let trip = tripsModel.getTrip(at: indexPath.row)
        
        
        if let t = trip {
            cell.textLabel?.text = t.getPlace()
            cell.detailTextLabel?.text = t.getDate()
        }

        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        tripsModel.rearrageTrips(from: fromIndexPath.row, to: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    @IBAction func editButtonDidTapped(_ sender: UIBarButtonItem) {
        // set tableView to editing mode when editButton is tapped
        if sender.title == "Edit" {
            sender.title = "Done"
            tableView.isEditing = true
        }
        
        else {
            sender.title = "Edit"
            tableView.isEditing = false
        }
    }
    
    
    // specific for editing one cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the trip from TripModel
            tripsModel.removeTrip(at: indexPath.row)
            
            // Remove the cell from tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
//        else if editingStyle == .insert {
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = tripsModel.getTrip(at: indexPath.row)
        self.despContent = selectedRow?.getDescription()
        PhotosModel.sharedInstance.currentTripId = indexPath.row
        TripMarksModel.sharedInstance.currentTripId = indexPath.row

        self.performSegue(withIdentifier: "ShowDetailSegue", sender: self)
//        print(selectedRow?.getDescription())
        
//        if let descriptionVC = storyboard?.instantiateViewController(identifier: "CellViewController") as? CellViewController {
//
//           descriptionVC.despContent = selectedRow?.getDescription()
         
       //     navigationController?.pushViewController(descriptionVC, animated: true)
//        }
//        let descriptionVC = CellViewController()
//        descriptionVC.descriptionTextView.text = tripsModel.getTrip(at: indexPath.row)?.getDescription()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.onComplete = {
                self.tableView.reloadData()
                
//                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if let tabBarVC = segue.destination as? TabBarController {
            tabBarVC.despContent = self.despContent
            }
        
       
       
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
