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
    
    var name: String
    var floors: [Int: FloorStatus]
    var direction: Bool?
    var currentFloor: Int
    var doorsOpen: Bool
    var status: String?
    
    struct FloorStatus {
        var Floor:Floor
        var UpStatus: Bool
        var DownStatus: Bool
    }
    
    // MARK: Initialization
    init?(name: String, doorsOpen: Bool, direction: Bool?, currentFloor: Int, status: String?){
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.doorsOpen = doorsOpen
        self.direction = direction
        self.currentFloor = currentFloor
        self.status = status
        self.floors = [:]
    }
    
    //MARK: Actions
    func addFloorToFloors(floor:Floor, upStatus: Bool, downStatus: Bool){
        floors[floor.Number] = FloorStatus(Floor: floor, UpStatus: upStatus, DownStatus: downStatus)
    }
    
    
    
    
    
}
