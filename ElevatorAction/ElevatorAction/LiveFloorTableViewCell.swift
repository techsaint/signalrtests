//
//  LiveFloorTableViewCell.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/25/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class LiveFloorTableViewCell: UITableViewCell {

    @IBOutlet weak var floorNameLabel: UILabel!
    @IBOutlet weak var Elevator1CallControl: ElevatorCallButtonControl!
    
    @IBOutlet weak var Elevator2CallControl: ElevatorCallButtonControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
