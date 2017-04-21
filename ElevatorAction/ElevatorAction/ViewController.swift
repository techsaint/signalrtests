//
//  ViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

        
    @IBOutlet weak var tblMain: UITableView!
    var building = Building()
    let upArrow = UIImage(named: "upArrow")
    let downArrow = UIImage(named: "downArrow")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMain.delegate = self
        tblMain.dataSource = self
        building.loadSampleData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ElevatorTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ElevatorTableViewCell else {
            fatalError("The dequeued cell is not an instance of ElevatorTableViewCell.")
        }
        let elevator = building.Elevators[indexPath.row]
        
        cell.nameLabel.text = elevator.name
        cell.floorLabel.text = building.Floors[elevator.currentFloor]?.Title
        if elevator.direction != nil{
            if elevator.direction == true {
                cell.directionImageView.image = self.upArrow
            }
            else {
                cell.directionImageView.image = self.downArrow
            }
        }
        if elevator.doorsOpen {
            cell.doorOpenLabel.text = "Doors open"
        }
        else {
            cell.doorOpenLabel.text = "Doors closed"
        }
        
        cell.backgroundColor = UIColor.lightGray
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return building.Elevators.count
    }


}

