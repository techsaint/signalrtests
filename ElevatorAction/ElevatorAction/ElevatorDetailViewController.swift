//
//  ElevatorDetailViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/26/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class ElevatorDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{
    var elevator: Elevator?
    var currentFloorName: String?
    
    @IBOutlet weak var FloorDisplay: UIImageView!
    
    @IBOutlet weak var floorNameLabel: UILabel!
    
    @IBOutlet weak var leftElevatorDoorImage: UIImageView!
    @IBOutlet weak var rightElevatorDoorImage: UIImageView!
    
    @IBOutlet weak var doorOpeningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doYourPath = UIBezierPath(rect: CGRect(x: 220, y: 155, width: 150, height: 2))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.fillColor = UIColor.lightGray.cgColor
        
        self.view.layer.addSublayer(layer)
        
        if let elevator = elevator {
            navigationItem.title = elevator.Name
            FloorDisplay.layer.borderColor = UIColor.lightGray.cgColor
            FloorDisplay.layer.borderWidth = 2
            floorNameLabel.text = currentFloorName
            if elevator.DoorsOpen {
                leftElevatorDoorImage.image = #imageLiteral(resourceName: "back")
                rightElevatorDoorImage.image = #imageLiteral(resourceName: "forward")
            }
            if elevator.DoorsOpen {
                doorOpeningLabel.text = "Open"
            }
            else {
                doorOpeningLabel.text = "Closed"
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
}
