//
//  FacebookOrEmailVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/5/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookOrEmailVC: UIViewController {
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingLabel.hidden = true
        facebookButton.hidden = false
        emailButton.hidden = false
        alreadyHaveAccountLabel.hidden = false
        logInButton.hidden = false
        
        
        
        DataService.ds.REF_BASE.childByAppendingPath("LCC").queryOrderedByValue().queryLimitedToLast(3).observeEventType(.ChildAdded, withBlock: { snapshot in
            print("The \(snapshot.key) dinosaur's score is \(snapshot.value)")
            print("nigger")
        })
        /*DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("993").childByAppendingPath("highscore").setValue("12")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("993").childByAppendingPath("playerName").setValue("nigger")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("994").childByAppendingPath("highscore").setValue("15")
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("994").childByAppendingPath("playerName").setValue("faggot")
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FacebookButton(sender: AnyObject) {
        
        
        let facebookLogin = FBSDKLoginManager()
        
    facebookLogin.logInWithReadPermissions(["email", "user_friends"]) {
            (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
        
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            }
            else if facebookResult.isCancelled {
                print("cancelled it")
            }
                
            else {
                self.loadingLabel.hidden = false
                self.facebookButton.hidden = true
                self.emailButton.hidden = true
                self.alreadyHaveAccountLabel.hidden = true
                self.logInButton.hidden = true
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    }
                    else {
                        
                        
                        //HE SAID SOMETHING ABOUT HOW IT'S BAD TO JUST DO LET USER HERE
                        
                       let user = ["provider": authData.provider]
                        //DataService.ds.REF_USERS.childByAppendingPath(authData.uid).setValue(user)
                        print("my authdata.uid is: \(authData.uid)")
                        
                        
                        var fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
                        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
                            if error == nil {
                                
                                print("Friends are : \(result)")
                                
                            } else {
                                
                                print("Error Getting Friends \(error)");
                                
                            }
                        }
                        
                        //get the name and email of whoever locked in through facebook
                        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken, version: nil, HTTPMethod: "GET")
                        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                            if(error == nil)
                            {
                                print("result \(result)")
                                print(result.valueForKey("name") as! String)
                                print("My ID in graphpath is: \(result.valueForKey("id") as! String)")
                                DataService.ds.REF_USERS.childByAppendingPath(result.valueForKey("id") as! String).setValue(user)
                                NSUserDefaults.standardUserDefaults().setValue(result.valueForKey("id") as! String, forKey: KEY_UID)
                            }
                            else
                            {
                                print("error \(error)")
                            }
                        })
                        //end of getting email and name with accesstoken through facebook
                        
                        self.performSegueWithIdentifier("logInNoNeedForSchoolPick", sender: nil)
                    }
                    
                })
            }
        }
        
        
        
    }
    
    
    
   

}
