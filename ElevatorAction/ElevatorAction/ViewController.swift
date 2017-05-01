//
//  ViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit
import SwiftR
import os.log

/*extension Notification.Name {
        static let reload = Notification.Name("reload")
    } */

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

        
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var elevatorTableView: UITableView!
    var building = Building()
    let upArrow = UIImage(named: "upArrow")
    let downArrow = UIImage(named: "downArrow")
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var Elevator1Label: UILabel!
    @IBOutlet weak var Elevator2Label: UILabel!
    

    @IBOutlet weak var ElevatorCar1Image: UIImageView!
    @IBOutlet weak var ElevatorCar1LeftDoorImage: UIImageView!
    @IBOutlet weak var ElevatorCar1RightDoorImage: UIImageView!
    
    
    @IBOutlet weak var ElevatorCar2Image: UIImageView!
     @IBOutlet weak var ElevatorCar2LeftDoorImage: UIImageView!

    @IBOutlet weak var ElevatorCar2RightDoorImage: UIImageView!
    
    var elevatorHub: Hub!
    var connection: SignalR!
    
    var previousFloor1 = 0
    var previousFloor2 = 0
    var previousOpen1 = false
    var previousOpen2 = false
    
    
    
    @IBAction func sendMessage(_ sender: AnyObject?) {
        /*let message = [
            "messageId": 1,
            "message": "Message Text",
            "detail": "This is a complex message",
            "items": ["foo", "bar", "baz"]
        ] as [String: Any]
        
        do {
          try elevatorHub.invoke("sendMessage", arguments: [message])
        } catch {
            print(error)
        }*/
        
        do {
            try elevatorHub.invoke("send", arguments: ["Simple Test", "This is a simple message"])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func startStop(_ sender: Any) {
        if startButton.title(for: UIControlState.normal) == "Start" {
            connection.start()
        } else {
            connection.stop()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testDates()
        tblMain.delegate = self
        tblMain.dataSource = self
        elevatorTableView.delegate = self
        elevatorTableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        self.ElevatorCar1Image.backgroundColor = UIColor.lightGray
        self.ElevatorCar2Image.backgroundColor = UIColor.lightGray
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        connection = SignalR("https://camelbacksignalrtest.azurewebsites.net")
        //connection.useWKWebView = true
        //connection.transport = .serverSentEvents
        connection.signalRVersion = .v2_2_0
        
        elevatorHub = Hub("camelBackHub")
        elevatorHub.on("receivedTelemetry") { [weak self] args in
            let m: AnyObject = args![0] as AnyObject
            //print(m)
            let d: [String: Any] = m as! [String: Any]
            let b = Building(building: d)
            self?.building = b
            self?.Elevator1Label.text = self?.building.Elevators[0].Name
            self?.Elevator2Label.text = self?.building.Elevators[1].Name
            DispatchQueue.main.async {
                self?.tblMain.reloadData()
                self?.elevatorTableView.reloadData()
            }
            let shouldShut1 = (self?.previousOpen1)! && !b.Elevators[0].DoorsOpen
            let shouldShut2 = (self?.previousOpen2)! && !b.Elevators[1].DoorsOpen
            let shouldShut = shouldShut1 || shouldShut2
            
            if(shouldShut){
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                    if shouldShut1{
                        self?.ElevatorCar1LeftDoorImage.center.x += CGFloat(16)
                        self?.ElevatorCar1RightDoorImage.center.x -= CGFloat(16)
                        self?.previousOpen1 = false
                    }
                    if shouldShut2{
                        self?.ElevatorCar2LeftDoorImage.center.x += CGFloat(16)
                        self?.ElevatorCar2RightDoorImage.center.x -= CGFloat(16)
                        self?.previousOpen2 = false
                    }

                }, completion: nil)

            }
            
            let floorchange1 = (self?.previousFloor1)! - b.Elevators[0].CurrentFloor
            let floorchange2 = (self?.previousFloor2)! - b.Elevators[1].CurrentFloor
            self?.previousFloor1 = b.Elevators[0].CurrentFloor
            self?.previousFloor2 = b.Elevators[1].CurrentFloor
            
            UIView.animate(withDuration: 5, delay: 0, options: .curveEaseInOut, animations: {
                
                self?.ElevatorCar1Image.center.y += CGFloat(floorchange1 * 40)
                self?.ElevatorCar1LeftDoorImage.center.y += CGFloat(floorchange1 * 40)
                self?.ElevatorCar1RightDoorImage.center.y += CGFloat(floorchange1 * 40)
                self?.ElevatorCar2Image.center.y += CGFloat(floorchange2 * 40)
                self?.ElevatorCar2LeftDoorImage.center.y += CGFloat(floorchange2 * 40)
                self?.ElevatorCar2RightDoorImage.center.y += CGFloat(floorchange2 * 40)
            }, completion: nil)
            
            let shouldOpen1 = !(self?.previousOpen1)! && b.Elevators[0].DoorsOpen
            let shouldOpen2 = !(self?.previousOpen2)! && b.Elevators[1].DoorsOpen
            let shouldOpen = shouldOpen1 || shouldOpen2
            
            if(shouldOpen){
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                    if shouldOpen1{
                        self?.ElevatorCar1LeftDoorImage.center.x -= CGFloat(16)
                        self?.ElevatorCar1RightDoorImage.center.x += CGFloat(16)
                        self?.previousOpen1 = true
                    }
                    if shouldOpen2{
                        self?.ElevatorCar2LeftDoorImage.center.x -= CGFloat(16)
                        self?.ElevatorCar2RightDoorImage.center.x += CGFloat(16)
                        self?.previousOpen2 = true
                    }
                    
                }, completion: nil)
                
            }

            
            
        }
        connection.addHub(elevatorHub)
        
        // SignalR events
       
        connection.starting = { [weak self] in
            self?.statusLabel.text = "Starting..."
            self?.startButton.isEnabled = false
        }
        
        connection.reconnecting = { [weak self] in
            self?.statusLabel.text = "Reconnecting..."
            self?.startButton.isEnabled = false
        }
        
        connection.connected = { [weak self] in
            print("Connection ID: \(self!.connection.connectionID!)")
            self?.statusLabel.text = "Connected"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Start", for: UIControlState.normal )

        }
        
        connection.reconnected = { [weak self] in
            self?.statusLabel.text = "Reconnected. Connection ID: \(self!.connection.connectionID!)"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Stop", for: UIControlState.normal)
        }
        
        connection.disconnected = { [weak self] in
            self?.statusLabel.text = "Disconnected"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Start", for: UIControlState.normal)
        }
        
        connection.connectionSlow = { print("Connection slow...") }
 
        connection.error = { [weak self] error in
            print("Error: \(error)")
            
            // Here's an example of how to automatically reconnect after a timeout.
            //
            // For example, on the device, if the app is in the background long enough
            // for the SignalR connection to time out, you'll get disconnected/error
            // notifications when the app becomes active again.
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self?.connection.start()
            }
        }
        connection.start()
        
        
        
        //building.loadSampleData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView === self.tblMain) {
        
            let cellIdentifier = "ElevatorTableViewCell"
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ElevatorTableViewCell else
            {
                fatalError("The dequeued cell is not an instance of ElevatorTableViewCell.")
            }
            let elevator = building.Elevators[indexPath.row]
        
            cell.nameLabel.text = elevator.Name
            cell.floorLabel.text = building.Floors[elevator.CurrentFloor]?.Title
            if elevator.Direction != nil{
                if elevator.Direction == true {
                    cell.directionImageView.image = self.upArrow
                }
                else {
                    cell.directionImageView.image = self.downArrow
                }
            }
            else{
                cell.directionImageView.image = nil
            }
            if elevator.DoorsOpen {
                cell.doorOpenLabel.text = "Doors open"
            }
            else {
                cell.doorOpenLabel.text = "Doors closed"
            }
        
        
            return cell
        }
        else {
            let cellIdentifier = "LiveFloorTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LiveFloorTableViewCell else
            {
                fatalError("The dequeued cell is not an instance of LiveFloorTableViewCell.")
            }
            let floor = building.Floors[(building.Floors.count - (indexPath.row + 1))]
            
            cell.floorNameLabel.text = (floor?.Title)!
            cell.Elevator1CallControl.upCalled = (floor?.Banks[1]?.UpStatus)!
            cell.Elevator1CallControl.downCalled = (floor?.Banks[1]?.DownStatus)!
            cell.Elevator2CallControl.upCalled = (floor?.Banks[2]?.UpStatus)!
            cell.Elevator2CallControl.downCalled = (floor?.Banks[2]?.DownStatus)!
            return cell

        }
        
    }
    
    func reloadTableData(notification: Notification) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        self.tblMain.reloadData()
        self.elevatorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView === self.tblMain) {
            return building.Elevators.count
        }
        else{
            return building.Floors.count
        }
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
            case "ShowDetail":
                guard let elevatorDetailViewController = segue.destination as? ElevatorDetailViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedElevatorCell = sender as? ElevatorTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                guard let indexPath = tblMain.indexPath(for: selectedElevatorCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                let selectedElevator = building.Elevators[indexPath.row]
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                elevatorDetailViewController.elevator = selectedElevator
                elevatorDetailViewController.currentFloorName = self.building.Floors[selectedElevator.CurrentFloor]?.Title
            default:
                fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    
    private func testDates() {
        let url = URL(string: "https://camelbacksignalrtest.azurewebsites.net/telemetry/averagewaittime/24hours")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "Service call failed")
        }
        task.resume()
    }


}

