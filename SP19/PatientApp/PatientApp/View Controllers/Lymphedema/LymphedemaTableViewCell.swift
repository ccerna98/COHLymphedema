//
//  LymphedemaTableViewCell.swift
//  PatientApp
//
//  Created by Engineering on 12/10/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class LymphedemaTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var LymphedemaCareItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
