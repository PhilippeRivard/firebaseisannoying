//
//  LogInVC.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/12/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var labelTest: UILabel!
    var university: University!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelTest.text = university.uniName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposue of any resources that can be recreated.
    }
    
    @IBAction func onBackBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSignUpBtnPressed(sender: AnyObject) {
        let randomPassword = randomStringWithLength(10)
        
       // isCorrectEmail(emailTextField.text!)
        var emailText = emailTextField.text
        var universityName = university.uniName
        
       
        
        DataService.ds.REF_BASE.createUser(emailTextField.text, password: randomPassword, withValueCompletionBlock: {
            error, result in
            
            if error == nil {
                print("user created")
                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                DataService.ds.REF_BASE.resetPasswordForUser(self.emailTextField.text, withCompletionBlock:  {
                    error in
                    
                    if error != nil {
                        print("error")
                    }
                    else {
                        print("email sent")
                        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "NeedsVerification")
                        
                        self.performSegueWithIdentifier("ResetPasswordVC", sender: nil)
                    }
                })
            }
                
            else if error.code == -5 {
                self.showErrorAlert("Invalid Email", message: "InvalidEmail")
            }
                
            
            else if error.code == -9 {
                self.showErrorAlert("User has already signed up", message: "You have already signed up with this email. You can click forgot your password or you can log in if you know your password")
            }
            else {
               print(error)
            }
        })
        
       
    }
    
    func randomStringWithLength (length : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString : NSMutableString = NSMutableString(capacity: length)
        for (var i=0; i < length; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResetPasswordVC" {
            if let ResetPasswordVC = segue.destinationViewController as? ResetPasswordVC {
                ResetPasswordVC.email = emailTextField.text
            }
            
        }
    }
    
    func isCorrectEmail(email: String) -> Bool {
        var endOfEmail = email.characters.split{$0 == "@"}.map(String.init)[1]
        let x = endOfEmail.rangeOfString(university.uniName)
       // for(var i=0; i<university.uniName.characters.count; i++){
         //   if(university.uniName.
       // }
        
        return true
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: "HELP!", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Aight.", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
