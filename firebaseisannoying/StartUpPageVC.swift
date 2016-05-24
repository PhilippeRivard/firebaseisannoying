//
//  StartUpPageVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/16/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class StartUpPageVC: UIViewController {
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print(FBSDKAccessToken.currentAccessToken().tokenString)
            print("youre already logged in")
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alreadyLoggedIn", userInfo: nil, repeats: true)
            // User is already logged in, do work such as go to next view controller.
            
        }
        else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "notLoggedIn", userInfo: nil, repeats: true)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alreadyLoggedIn() {
        performSegueWithIdentifier("AlreadyLoggedIn", sender: nil)
    }
    func notLoggedIn() {
        performSegueWithIdentifier("FacebookOrEmailVC", sender: nil)
    }
    

}
