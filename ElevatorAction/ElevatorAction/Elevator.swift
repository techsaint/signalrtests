//
//  Elevator.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class Elevator {
    
    // MARK: Properties
    var ElevatorId:Int
    var Name: String
    var Direction: Bool?
    var CurrentFloor: Int
    var DoorsOpen: Bool
    var Status: String?
    
    
    // MARK: Initialization
    init?(elevatorId: Int, name: String, doorsOpen: Bool, direction: Bool?, currentFloor: Int, status: String?){
        guard !name.isEmpty else {
            return nil
        }
        self.ElevatorId = elevatorId
        self.Name = name
        self.DoorsOpen = doorsOpen
        self.Direction = direction
        self.CurrentFloor = currentFloor
        self.Status = status
    }
    
    init?(elevator: [String: Any]){
        self.ElevatorId = elevator["ElevatorId"] as! Int
        self.Name = elevator["Name"] as! String
        self.DoorsOpen = elevator["DoorsOpen"] as! Bool
        if (elevator["Direction"] as? NSNull) != nil{
            self.Direction = nil
        }
        if (elevator["Direction"] as? Bool) != nil {
            self.Direction = elevator["Direction"] as? Bool
        }
        self.CurrentFloor = elevator["CurrentFloor"] as! Int
        self.Status = elevator["Status"] as! String?
    
    }
    
    //MARK: Actions
    //func addFloorToFloors(floor:Floor, upStatus: Bool, downStatus: Bool){
    //    floors[floor.Number] = FloorStatus(Floor: floor, UpStatus: upStatus, DownStatus: downStatus)
    //}
    
    
    
    
    
}
