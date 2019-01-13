//
//  LoginViewController.swift
//  reportaraid
//
//  Created by Hayden Hong on 1/12/19.
//  Copyright © 2019 Hayden Hong. All rights reserved.
//
import UIKit
import Foundation
import Pastel
import UserNotifications

class LoginViewController: UIViewController {
    @IBOutlet var SomeView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
        loginButton.clipsToBounds = true

        
        // Request permission to display alerts and play sounds.
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Do nothing, this is okay lol
        }
    }
    
    // login (segue currently performed in the storyboard
    @IBAction func loginButtonClicked(_ sender: Any) {
        
    }
}
