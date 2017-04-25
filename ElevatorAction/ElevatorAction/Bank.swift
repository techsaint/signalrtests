//
//  FloorStatus.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/24/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class Bank{
    
    var FloorId:Int
    var ElevatorId:Int
    var UpStatus: Bool
    var DownStatus: Bool
    
    init(FloorId:Int, ElevatorId:Int, UpStatus: Bool, DownStatus: Bool) {
        self.FloorId = FloorId
        self.ElevatorId = ElevatorId
        self.UpStatus = UpStatus
        self.DownStatus = DownStatus
    }
    
    init(bank: [String: Any]) {
        self.FloorId = bank["FloorId"] as! Int
        self.ElevatorId = bank["ElevatorId"] as! Int
        self.UpStatus = bank["UpStatus"] as! Bool
        self.DownStatus = bank["DownStatus"] as! Bool
    }

    
}
