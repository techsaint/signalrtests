//
//  MinAvgMaxFloor.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 5/2/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class minAvgMaxFloor {
    
    var floor:String
    var min:Double
    var avg:Double
    var max:Double
    
    init(floor:String, min:Double, avg:Double, max:Double) {
        self.floor = floor
        self.min = min
        self.avg = avg
        self.max = max
    }
    
    init(data: [String: Any]) {
        self.floor = data["floor"] as! String
        self.min = data["min"] as! Double
        self.avg = data["avg"] as! Double
        self.max = data["max"] as! Double
    }
    
}

