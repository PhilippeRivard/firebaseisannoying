//
//  SchoolLeaderboardVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/15/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase



class SchoolLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var rankingStaticLabel: UILabel!
    
    @IBOutlet weak var playerStaticLabel: UILabel!
    
    @IBOutlet weak var scoreStaticLabel: UILabel!
    
    @IBOutlet weak var schoolSignUpBtn: UIButton!
    
    
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
    var mySchool: String?
    var originalColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        schoolSignUpBtn.hidden = false
        
        originalColor = schoolButton.backgroundColor
        schoolButton.backgroundColor = UIColor.grayColor()
        
        tableView.hidden = true
        schoolNameLabel.hidden = true
        rankingStaticLabel.hidden = true
        playerStaticLabel.hidden = true
        scoreStaticLabel.hidden = true
 
        
        print("gay")
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
            self.loadingLabel.hidden = true
            self.tableView.hidden = false
        })
        /*
        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("school").observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("pussy")
            if snapshot.value as? String != nil {
                print("there is a school")
                self.schoolSignedUp()
                self.mySchool = snapshot.value as! String
                self.schoolNameLabel.text = snapshot.value as! String
                DataService.ds.REF_BASE.childByAppendingPath(self.mySchool).observeSingleEventOfType(.Value, withBlock: {
                    snapshot in
                    self.numberOfNodes = Int(snapshot.childrenCount)
                    print("number of nodes: \(self.numberOfNodes)")
                })
                self.redoPopulate()
                
            }
            else {
                self.noSchoolSignedUp()
            }
 */
            //print(String(snapshot.value))
            /*
             if snapshot.value != nil {
             self.tableView.hidden = false
             }
             */
        //})
        /*
        print("fag")
        if mySchool != nil {
            DataService.ds.REF_BASE.childByAppendingPath(mySchool).observeEventType(.ChildChanged, withBlock: { snapshot in
                
                self.childWasAdded = true
                self.redoPopulate()
            })
        }
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        players.sortInPlace { (element1, element2) -> Bool in
            return element1.highscore > element2.highscore
        }
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
                DataService.ds.REF_BASE.childByAppendingPath(mySchool).removeAllObservers()
                
                player = players[indexPath.row]
                print("not nil")
                cell.configureCell(player, number: indexPath.row)
                print(players[indexPath.row].highscore)
            }
            
            
            
            
            
            
            return cell
        }
 */
            
            
        else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func redoPopulate() {
        players.removeAll()
        backwardsArrayFinished = false
        DataService.ds.REF_BASE.childByAppendingPath(mySchool).observeEventType(.ChildAdded, withBlock: { snapshot in
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
            
        })
    }
    @IBAction func onFriendsBtnPressed(sender: AnyObject) {
        schoolButton.backgroundColor = originalColor
        friendsButton.backgroundColor = UIColor.grayColor()
        performSegueWithIdentifier("SchoolToFriends", sender: nil)
    }
    
    @IBAction func onLocationBtnPressed(sender: AnyObject) {
        schoolButton.backgroundColor = originalColor
        locationButton.backgroundColor = UIColor.grayColor()
        performSegueWithIdentifier("SchoolToLocation", sender: nil)
    }
    
    
    @IBAction func onSchoolSignUpBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("PickSchoolVC", sender: nil)
        
    }
    
    
    func noSchoolSignedUp() {
        tableView.hidden = true
        schoolNameLabel.hidden = true
        rankingStaticLabel.hidden = true
        playerStaticLabel.hidden = true
        scoreStaticLabel.hidden = true
        schoolSignUpBtn.hidden = false
    }
    func schoolSignedUp() {
        tableView.hidden = false
        schoolNameLabel.hidden = false
        rankingStaticLabel.hidden = false
        playerStaticLabel.hidden = false
        scoreStaticLabel.hidden = false
        schoolSignUpBtn.hidden = true
    }
    

}
