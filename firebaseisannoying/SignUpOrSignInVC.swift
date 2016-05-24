//
//  SignUpOrSignInVC.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/12/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit


class SignUpOrSignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogInPressed(sender: AnyObject) {
        
        if let email = emailTextField.text where email != "", let pass = passwordTextField.text where pass != "" {
           // DataService.ds.REF_BASE.createUser(email, password: pass, withValueCompletionBlock: {
             //   error, result in
               // if error != nil {
                 //   print(error)
                //}
            //    else {
              //      print("you created")
                //}
            //})
            
            DataService.ds.REF_BASE.authUser(email, password: pass, withCompletionBlock: {
                error, authData in
                if error != nil {
                    print(error)
                    
                    
                    
                    
                    //DEAL WITH ALL THE ERRORS: PASSWORD INCORRECT BUT EMAIL IS IN DATABASE, EMAIL IS NOT IN DATABASE
              
                   // if error.code == STATUS_ACCOUNT_NONEXIST {
                        //DataService.ds.REF_BASE.createUser(email, password: pass, withValueCompletionBlock: { error, result in
                            
                          //  if error != nil {
                               // self.showErrorAlert("Account could not be created", message: "Try a different email or password or account hasn't signed up")
                           // }
                           // else {
                                //NSUserDefaults.standardUserDefaults().setValue([KEY_UID], forKey: KEY_UID)
                                
                                //DataService.ds.REF_BASE.createUser(email, password: pass, withCompletionBlock: nil)
                                //self.performSegueWithIdentifier("HomePageVC", sender: nil)
                            //}
                      // })
                    
                    //}
            
            
            
            
            
            
            
                }
                else if(NSUserDefaults.standardUserDefaults().boolForKey("NeedsVerification")){
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "NeedsVerification")
                    self.performSegueWithIdentifier("ResetPasswordVC", sender: nil)
                    
                } else{
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IsLoggedIn")
                    NSUserDefaults.standardUserDefaults().setValue(self.emailTextField.text, forKey: "UserEmail")
                    self.performSegueWithIdentifier("HomePageVC", sender: nil)
                    
                    
                }
            
            })
        }
        else {
            showErrorAlert("Email and Password Required", message: "Please enter your email and password")
        }
        
       
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: "HELP!", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Aight.", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResetPasswordVC" {
            if let ResetPasswordVC = segue.destinationViewController as? ResetPasswordVC{
                ResetPasswordVC.email = emailTextField.text
            }
        }
    }
    
    @IBAction func onForgotPasswordPressed(sender: AnyObject) {
        performSegueWithIdentifier("ResetPasswordVC", sender: nil)
    }
    
}
