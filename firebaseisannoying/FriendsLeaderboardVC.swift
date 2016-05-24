//
//  ViewController.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/3/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class FriendsLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var friendsButton: UIButton!
    
    @IBOutlet weak var schoolButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    var highScore: String?
    var currentPlayerName: String?
    var counter = 0
    var players = [Player]()
    var numberOfNodes: Int?
    var backwardsArrayFinished = false
    var childWasAdded = false
    var originalColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        
        originalColor = friendsButton.backgroundColor
        
        friendsButton.backgroundColor = UIColor.grayColor()
        
        
        returnUserData()
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urmom").setPriority(16)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urdad").setPriority(12)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("urbro").setPriority(1)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("queef").setPriority(71)
        DataService.ds.REF_BASE.childByAppendingPath("LCC").childByAppendingPath("faggot").setPriority(5)
         
 */
        
        //THIS IS THE RIGHT THING
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.Value, withBlock: { snapshot in
            self.players = []
            self.backwardsArrayFinished = false
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    let player = Player(playerName: snap.key, highscore: (snap.value as? Int)!)
                    self.players.append(player)
                    
                }
            }
            self.players = self.players.reverse()
            self.tableView.reloadData()
        })
         
         //THIS IS THE RIGHT THING
 */
        
        
        
        
        
        /*
        DataService.ds.REF_USERS.childByAppendingPath("facebook:10209204778739230").childByAppendingPath("school").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value as? String != nil {
                self.tableView.hidden = false
                
            }
            print(String(snapshot.value))
            /*
            if snapshot.value != nil {
                self.tableView.hidden = false
            }
 */
        })
 */
        /*
 
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            self.numberOfNodes = Int(snapshot.childrenCount)
            
            self.tableView.reloadData()
        })
 */
        
        
        //IM NOT SURE IF I SHOULD USE QUERYORDEREDBYVALUE OR JUST REGULAR OBSERVE EVENT???????
        
        
        
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
            //print("The \(snapshot.key) dinosaur's score is \(snapshot.value)")
            
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
        })
        */
        
        //self.redoPopulate()
        /*
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.counter += 1
            if self.counter == self.numberOfNodes {
                self.redoPopulate()
            }
            
        })
         
         */
 
        
        /*
        
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildChanged, withBlock: { snapshot in
            self.childWasAdded = true
            self.redoPopulate()
            
            
        })
 
        */
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        players.sortInPlace { (element1, element2) -> Bool in
            return element1.highscore > element2.highscore
        }
        print(players[0].highscore)
        
        
        let player = players[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell") as? RankingCell {
            
            cell.configureCell(player, number: indexPath.row)
             
            return cell
            
            
        }
 
        
        
        /*
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as? RankingCell {
            let player: Player!
            
            if players.count == numberOfNodes {
                if backwardsArrayFinished == false {
                    players = players.reverse()
                    backwardsArrayFinished = true
                }
                DataService.ds.REF_BASE.childByAppendingPath("LCC").removeAllObservers()
                
                player = players[indexPath.row]
                print("not nil")
                cell.configureCell(player, number: indexPath.row)
                print(players[indexPath.row].highscore)
            }
            
            
          
            
            
            
            return cell
        }
 */
            
        
        else {
            return RankingCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redoPopulate() {
        players.removeAll()
        backwardsArrayFinished = false
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func onSchoolBtnPressed(sender: AnyObject) {
        friendsButton.backgroundColor = originalColor
        schoolButton.backgroundColor = UIColor.grayColor()
        performSegueWithIdentifier("FriendsToSchool", sender: nil)
        
    }
    
    @IBAction func onLocationBtnPressed(sender: AnyObject) {
        friendsButton.backgroundColor = originalColor
        locationButton.backgroundColor = UIColor.grayColor()
        performSegueWithIdentifier("FriendsToLocation", sender: nil)
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                self.players = []
                self.backwardsArrayFinished = false
                print("fetched user: \(result)")
                //let userName : NSString = result.valueForKey("name") as! NSString
                //print("User Name is: \(userName)")
                //let userEmail : NSString = result.valueForKey("email") as! NSString
                //print("User Email is: \(userEmail)")
                print(result.valueForKey("data")!)
                let friends = result.valueForKey("data") as! NSArray
                    print(friends[0].valueForKey("id"))
                for friend in friends {
                    print("youre gay")
                    DataService.ds.REF_USERS.childByAppendingPath(friend.valueForKey("id") as! String).observeSingleEventOfType(.Value, withBlock: { snapshot in
                        print("I'M IN THE ID")
                        print(friend.valueForKey("name") as! String)
                        print(snapshot.childSnapshotForPath("highscore").value as! Int)
                        let player = Player(playerName: friend.valueForKey("name") as! String, highscore: snapshot.childSnapshotForPath("highscore").value as! Int)
                        self.players.append(player)
                        print("you're gayer")
                        print(self.players)
                        if self.players.count == friends.count {
                            self.tableView.reloadData()
                            self.loadingLabel.hidden = true
                            self.tableView.hidden = false
                        }
                        
                    })
                    
                }
                print(self.players)
                //self.tableView.reloadData()
                
            }
        })
    }
    


}

