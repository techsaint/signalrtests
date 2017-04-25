//
//  Floor.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import Foundation

class Floor{
    
    var FloorId:Int
    var Title:String
    var Banks: [Int: Bank]
    
    init(FloorId:Int, Title:String) {
        self.FloorId = FloorId
        self.Title = Title
        self.Banks = [:]
    }
    
    init(floor: [String: Any]) {
        self.FloorId = floor["FloorId"] as! Int
        self.Title = floor["Title"] as! String
        self.Banks = [:]
        let banks = floor["Banks"] as! [[String: Any]]
        
        for b in banks {
            let bank = Bank(bank: b)
            self.Banks[bank.ElevatorId] = bank
        }
        
    }
    
    func addBankToFloors(ElevatorId:Int,  upStatus: Bool, downStatus: Bool){
        Banks[ElevatorId] = Bank(FloorId: self.FloorId, ElevatorId: ElevatorId, UpStatus: upStatus, DownStatus: downStatus)
    }

    
}
