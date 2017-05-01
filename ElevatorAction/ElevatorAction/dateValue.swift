//
//  dateValueData.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/28/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class dateValue {
    
    var date:String
    var value:Double
    
    init(date:String, value:Double) {
        self.date = date
        self.value = value
    }
    
    init(data: [String: Any]) {
        self.date = data["date"] as! String
        self.value = data["value"] as! Double
    }
    
}
