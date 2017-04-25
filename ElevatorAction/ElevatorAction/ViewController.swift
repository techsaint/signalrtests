//
//  ViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 4/20/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit
import SwiftR

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

        
    @IBOutlet weak var tblMain: UITableView!
    var building = Building()
    let upArrow = UIImage(named: "upArrow")
    let downArrow = UIImage(named: "downArrow")
 
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTextView: UITextView!
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
        
        connection = SignalR("https://otistestsignalrhubtest.azurewebsites.net")
        //connection.useWKWebView = true
        //connection.transport = .serverSentEvents
        connection.signalRVersion = .v2_2_0
        
        elevatorHub = Hub("otisHub")
        elevatorHub.on("receivedTelemetry") { [weak self] args in
            let m: AnyObject = args![0] as AnyObject
            let d: [String: Any] = m as! [String: Any]
            let b = Building(building: d)
            print(b)
            self?.tblMain.reloadData()
            
        }
        connection.addHub(elevatorHub)
        
        // SignalR events
       
        connection.starting = { [weak self] in
            self?.statusLabel.text = "Starting..."
            self?.startButton.isEnabled = false
            self?.sendButton.isEnabled = false
        }
        
        connection.reconnecting = { [weak self] in
            self?.statusLabel.text = "Reconnecting..."
            self?.startButton.isEnabled = false
            self?.sendButton.isEnabled = false
        }
        
        connection.connected = { [weak self] in
            print("Connection ID: \(self!.connection.connectionID!)")
            self?.statusLabel.text = "Connected"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Start", for: UIControlState.normal )
            self?.sendButton.isEnabled = true
        }
        
        connection.reconnected = { [weak self] in
            self?.statusLabel.text = "Reconnected. Connection ID: \(self!.connection.connectionID!)"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Stop", for: UIControlState.normal)
            self?.sendButton.isEnabled = true
        }
        
        connection.disconnected = { [weak self] in
            self?.statusLabel.text = "Disconnected"
            self?.startButton.isEnabled = true
            self?.startButton.setTitle("Start", for: UIControlState.normal)
            self?.sendButton.isEnabled = false
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return building.Elevators.count
    }


}

