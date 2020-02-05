//
//  LymphedemaInfoViewController.swift
//  PatientApp
//
//  Created by Engineering on 12/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class LymphedemaInfoViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

        // This variable will hold the data being passed from the First View Controller
        var receivedData = ""

        override func viewDidLoad() {
            super.viewDidLoad()

            print(receivedData)
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


