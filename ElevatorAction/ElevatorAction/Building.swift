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
    
    func loadSampleData(){

        
        let elevator1 = Elevator(name: "Main", doorsOpen: false, direction: false, currentFloor: 1, status: "none")
        let elevator2 = Elevator(name: "Service", doorsOpen: false, direction: true, currentFloor: 2, status: "none")
        
        self.Elevators.append(elevator1!)
        self.Elevators.append(elevator2!)
        
        for i in 1...5 {
            let f = Floor(number: i, title: "\(i)");
            self.Floors[i] = f
            for elevator in self.Elevators{
                elevator.addFloorToFloors(floor: f, upStatus: false, downStatus: false)
            }
        }
    }

    
}
