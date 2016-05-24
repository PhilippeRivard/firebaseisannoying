//
//  ResetPasswordVC.swift
//  NotSureIfThisWorks
//
//  Created by Oli Eydt on 2016-01-14.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit


class ResetPasswordVC: UIViewController {
    
    var email: String!
    
   
    
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var buttonOldPass: UIButton!
    @IBOutlet var buttonNewPass: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOldPassPressed(sender: AnyObject) {
        DataService.ds.REF_BASE.authUser(email, password: oldPasswordTextField.text, withCompletionBlock: {
            error, authData in
            if error == nil {
                self.newPasswordTextField.hidden=false
                self.confirmPasswordTextField.hidden=false
                self.oldPasswordTextField.hidden=true
                self.buttonOldPass.hidden=true
                self.buttonNewPass.hidden=false
            }
            
            else if error.code == -8 {
                self.showErrorAlert("Please Enter A Password", message: "Please enter a password")
            }
            
            else if error.code == -6 {
                self.showErrorAlert("Incorrect Password", message: "Incorrect Password")
            }
            else{
                print(error)
            }
        })
        
    }
    @IBAction func onSendBtnPressed(sender: AnyObject) {
        if(newPasswordTextField.text == confirmPasswordTextField.text){
            DataService.ds.REF_BASE.changePasswordForUser(email, fromOld: oldPasswordTextField.text, toNew: newPasswordTextField.text, withCompletionBlock: {
                error in
                if error != nil{
                    print(error)
                } else{
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IsLoggedIn")
                    NSUserDefaults.standardUserDefaults().setValue(self.email, forKey: "UserEmail")
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "NeedsVerification")
                    
                    
                    //set backbone for name
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("name").setValue(self.email)
                    
                    //set backbone for inQueue
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inQueue").setValue(false)
                    
                    //set backbone for online
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(false)
                    
                    //set backbone for wins
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("wins").setValue(0)
                    
                    //set backbone for losses
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("losses").setValue(0)
                    
                    //set backbone for inGame
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("opponent").setValue("")
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("myScore").setValue(0)
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("opponentScore").setValue(0)
                    
                    self.performSegueWithIdentifier("HomePageVC", sender: nil)
                    
                }
            })
            
            
        } else{
            showErrorAlert("Passwords do not match", message: "Passwords do not match, please learn how to type")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: "HELP!", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Aight.", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSignOutBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("SignUpOrSignInVC", sender: nil)
    }
    
}
