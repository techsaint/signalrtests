//
//  Building.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class Building{
    
    var Floors:[Int:Floor]
    var Elevators:[Elevator]
    
    init() {
        self.Floors = [Int:Floor]()
        self.Elevators = [Elevator]()
    }
    
    init(building: [String: Any]) {
        self.Floors = [Int:Floor]()
        self.Elevators = [Elevator]()
        let floors = building["Floors"] as? [[String: Any]]
        let elevators = building["Elevators"] as? [[String: Any]]
        for e in elevators!{
            let elevator = Elevator(elevator: e)
            self.Elevators.append(elevator!)
        }
 
        for f in floors!{
            let floor = Floor(floor: f)
            self.Floors[floor.FloorId] = floor
        }
    }
    
    func loadSampleData(){
        
        
        let elevator1 = Elevator(elevatorId: 1, name: "Main", doorsOpen: false, direction: false, currentFloor: 1, status: "none")
        let elevator2 = Elevator(elevatorId:2, name: "Service", doorsOpen: false, direction: true, currentFloor: 2, status: "none")
        
        self.Elevators.append(elevator1!)
        self.Elevators.append(elevator2!)
        
        for i in 1...5 {
            let f = Floor(FloorId: i, Title: "\(i)");
            self.Floors[i] = f
            for elevator in self.Elevators{
                f.addBankToFloors(ElevatorId: elevator.ElevatorId, upStatus: true, downStatus: true)
            }
        }
    }
    
    
}
