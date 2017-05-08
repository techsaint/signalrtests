//
//  LoginViewController.swift
//  ElevatorAction
//
//  Created by Joseph Ellis II on 5/4/17.
//  Copyright © 2017 BlueMetal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func attemptLogin(_ sender: Any) {
        if usernameField.text == "elevator@camelback.net" && passwordField.text == "test" {
            performSegue(withIdentifier: "successfulLogin", sender: self)
        }
        else {
            passwordField.text = ""
            statusLabel.text = "Username or Password not recognised"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text = "elevator@camelback.net"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = "Logout"
        backItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(colorLiteralRed: 118/255, green: 201/255, blue: 251/255, alpha: 1)], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backItem
    }
    

}
