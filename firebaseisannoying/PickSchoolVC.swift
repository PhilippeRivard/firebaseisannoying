//
//  FirstViewController.swift
//  Swaggerz
//
//  Created by Oli Eydt on 2015-12-21.
//  Copyright (c) 2015 Swaggerz Light. All rights reserved.
//

import UIKit
import AVFoundation

class PickSchoolVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var keyboardHeightLayoutConstraint2: NSLayoutConstraint!
    
    var universities = [University]()
    var filteredUniversities = [University]()
    var chosenUniversity: University!
    var signedIn = true
    var inSearchMode = true
    var tableViewBottomConstraint: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        parseUniversitiesCSV()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
       
      
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func parseUniversitiesCSV() {
        let path = NSBundle.mainBundle().pathForResource("UniListUSA", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let uniName = row["uni_name"]!
                let uniState = row["uni_state"]!
                let university = University(uniName: uniName, uniState: uniState)
                universities.append(university)
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var university: University!
        
        if inSearchMode {
            university = filteredUniversities[indexPath.row]
        }
        else {
            university = universities[indexPath.row]
        }
        
        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String).childByAppendingPath("pickedSchool").setValue(true)
        
        performSegueWithIdentifier("PickedSchool", sender: university)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SchoolSearchCell", forIndexPath: indexPath) as? SchoolSearchCell {
            let university: University!
            if inSearchMode {
                university = filteredUniversities[indexPath.row]
            }
            else {
                university = universities[indexPath.row]
            }
            cell.configureCell(university)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredUniversities.count
        }
        return universities.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUpVC" {
            if let SignUpVC = segue.destinationViewController as? SignUpVC {
                if let university = sender as? University {
                    SignUpVC.university = university
                }
            }
        }
    }
    
    //SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredUniversities = universities.filter({$0.uniName.lowercaseString.rangeOfString(lower) != nil})
        if searchBar.text == "" || searchBar.text == nil {
            searchBar.resignFirstResponder()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
            tableView.reloadData()
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint2?.constant = endFrame?.size.height ?? 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    @IBAction func onBackBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



