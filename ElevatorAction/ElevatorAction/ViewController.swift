//
//  ViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit
import SwiftR

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
    
    var elevatorHub: Hub!
    var connection: SignalR!
    
    
    
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
        tblMain.delegate = self
        tblMain.dataSource = self
        elevatorTableView.delegate = self
        elevatorTableView.dataSource = self
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        connection = SignalR("https://camelbacksignalrtest.azurewebsites.net")
        //connection.useWKWebView = true
        //connection.transport = .serverSentEvents
        connection.signalRVersion = .v2_2_0
        
        elevatorHub = Hub("camelBackHub")
        elevatorHub.on("receivedTelemetry") { [weak self] args in
            let m: AnyObject = args![0] as AnyObject
            print(m)
            let d: [String: Any] = m as! [String: Any]
            let b = Building(building: d)
            self?.building = b
            DispatchQueue.main.async {
                self?.tblMain.reloadData()
                self?.elevatorTableView.reloadData()
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
            if elevator.DoorsOpen {
                cell.doorOpenLabel.text = "Doors open"
            }
            else {
                cell.doorOpenLabel.text = "Doors closed"
            }
        
            cell.backgroundColor = UIColor.lightGray
        
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


}

