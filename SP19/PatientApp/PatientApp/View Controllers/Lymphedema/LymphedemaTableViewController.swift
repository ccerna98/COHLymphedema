//
//  LymphedemaTableViewController.swift
//  
//
//  Created by Engineering on 12/8/19.
//

import UIKit


struct LymphedemaCareItem {

    var id : Int
    var title : String
    // var text : String
    // var image : String

}


// color theme of this view controller
private let colorTheme = UIColor(named: "yellow")!

// global variables
private let cellIdentifier: String = "LabelCellIdentifier"

// subviews
private let headerView = Header()
private let lymphedemaTable = UITableView()

class LymphedemaTableViewController: UITableViewController {
    
    var lymphCareSections = [
        LymphedemaCareItem(id: 1, title: "Take a BIS Measurement"),
        LymphedemaCareItem(id: 2, title: "What is Lymphedema?"),
        LymphedemaCareItem(id: 3, title: "Massage Tutorials"),
        LymphedemaCareItem(id: 4, title: "Garment Fitting"),
        LymphedemaCareItem(id: 5, title: "Symptoms Survey")
    ]

//
    override func viewDidLoad() {
        super.viewDidLoad()
//        // set the tab bar item title and image
//        self.tabBarItem.selectedImage = UIImage(named: "home")!
//        self.tabBarItem.title = "Lymphedema"
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lymphCareSections.count
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let LymphedemaCareItem = lymphCareSections[indexPath.row]
        cell.textLabel?.text = LymphedemaCareItem.title

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
//   // method to run when table view cell is tapped
//      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//           // Segue to the second view controller
//           self.performSegue(withIdentifier: "yourSegue", sender: self)
//       }
//
//       // This function is called before the segue
//       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//           // get a reference to the second view controller
//           let secondViewController = segue.destination as! LymphedemaInfoViewController
//
//           // set a variable in the second view controller with the data to pass
//       }
   }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    



