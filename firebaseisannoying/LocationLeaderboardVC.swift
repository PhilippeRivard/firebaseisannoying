//
//  FriendsLeaderboardVC.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/15/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import MapKit
import CoreLocation

class LocationLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var highScore: String?
    var regions = [String]()
    var currentPlayerName: String?
    var counter = 0
    var players = [Player]()
    var numberOfNodes: Int?
    var backwardsArrayFinished = false
    var childWasAdded = false
    let geocode = CLGeocoder()
    var firstUpdate = false
    var myCity: String = ""
    var mycounter = 0
    
    var specificLocationWanted: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regions = ["asdf","eee","gdfs","grrrr"]
        firstUpdate = false
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.hidden = true
        
        //getPickerViewValues()
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
 
        
        
        
        
        
        
        
 
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        specificLocationWanted = regions[row]
        self.view.endEditing(true)
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    */
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
        DataService.ds.REF_BASE.childByAppendingPath("LCC").observeEventType(.ChildAdded, withBlock: { snapshot in
            self.players.append(Player(playerName: snapshot.key, highscore: (snapshot.value as? Int)!))
            self.tableView.reloadData()
            
        })
    }
    
    
    @IBAction func onFriendsBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("LocationToFriends", sender: nil)
        
    }
    
    
    @IBAction func onSchoolBtnPressed(sender: AnyObject) {
        performSegueWithIdentifier("LocationToSchool", sender: nil)
    }
    /*
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            print(locationManager.location!.coordinate.latitude)
            
        }
        else {
            locationManager.requestWhenInUseAuthorization()
            print(locationManager.location)
        }
    }
 */
    
    /*
     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     print("fag")
     }
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    /*
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(manager.location!, completionHandler: { (placemark, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if placemark!.count > 0 {
                let pm = placemark![0] as CLPlacemark
                print("locality is: \(pm.locality)")
                
            } else {
                print("Error with data")
            }
        })
    }
 */
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //get my location
        if firstUpdate == false {
            /*
            DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("latitude").setValue(locValue.latitude)
            DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("longitude").setValue(locValue.longitude)
            */
           // print("first locations = \(locValue.latitude) \(locValue.longitude)")
            
            geocode.reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemark, error) -> Void in
                print("first geocode")
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                if placemark!.count > 0 {
                    let pm = placemark![0] as CLPlacemark
                    
                    
                    
                    // Address dictionary
                    print(pm.addressDictionary)
                    
                    // Location name
                    if let locationName = pm.addressDictionary!["Name"] as? NSString {
            
                        print("location name: \(locationName)")
                        self.locationLabel.text = locationName as String
                    }
                    
                    // Street address
                    if let street = pm.addressDictionary!["Thoroughfare"] as? NSString {
                        print("street name is: \(street)")
                    }
                    
                    // City
                    if let city = pm.addressDictionary!["City"] as? NSString {
                        print("city is: \(city)")
                        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("city").setValue(city)
                        self.myCity = city as String
                        
                    }
                    
                    if let state = pm.addressDictionary!["State"] as? NSString {
                        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("state").setValue(state)
                    }
                    
                    // Zip code
                    if let zip = pm.addressDictionary!["ZIP"] as? NSString {
                        print("zip is: \(zip)")
                        
                    }
                    
                    // Country
                    if let country = pm.addressDictionary!["Country"] as? NSString {
                        print("country is: \(country)")
                        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("country").setValue(country)
                    }
                    
                    if let subAdministrativeArea = pm.addressDictionary!["SubAdministrativeArea"] as? NSString {
                        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").childByAppendingPath("subAdministrativeArea").setValue(subAdministrativeArea)
                    }
                    //print("is: \(pm)")
                    DataService.ds.REF_USERS.observeEventType(.Value, withBlock: { snapshot in
                        self.players = []
                        self.backwardsArrayFinished = false
                        print("dataservice")
                        print(snapshot.children.allObjects.count)
                        
                        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                            for snap in snapshots {
                                if snap.childSnapshotForPath("currentLocation").childSnapshotForPath("city").value as! String == self.myCity && snap.key as! String != NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String {
                                let player = Player(playerName: snap.childSnapshotForPath("name").value as! String, highscore: snap.childSnapshotForPath("highscore").value as! Int)
                                self.players.append(player)
                                }
                                
                            }
                        }
                        //self.players = self.players.reverse()
                        
                        
                        self.tableView.reloadData()
                        //self.loadingLabel.hidden = true
                        
                    })
                    
                    
                } else {
                    print("Error with data")
                }
            })
 
            
            //update tableview
            
            
 
            
            self.firstUpdate = true
        }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.tableView.reloadData()
        print("should refresh tableview")
        self.tableView.hidden = false
    }
    
    
    func goToFirebase() {
        DataService.ds.REF_USERS.observeEventType(.Value, withBlock: { snapshot in
            self.players = []
            self.backwardsArrayFinished = false
            print("dataservice")
            print(snapshot.children.allObjects.count)
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    
                    print("this is the snap: \(snap)")
                    print("gay")
                    print(self.mycounter++)
                    
                    let locationData = CLLocation(latitude: snap.childSnapshotForPath("currentLocation").childSnapshotForPath("latitude").value as! Double, longitude: snap.childSnapshotForPath("currentLocation").childSnapshotForPath("longitude").value as! Double)
                    print("this is extremely gay")
                    //let geocode2 = CLGeocoder()
                    // print(locationData)
                    self.geocode.reverseGeocodeLocation(locationData, completionHandler: { (placemark, error) -> Void in
                        print("only in geocode")
                        if error != nil {
                            print("Error: \(error!.localizedDescription)")
                            return
                        }
                        if placemark!.count > 0 {
                            let pm = placemark![0] as CLPlacemark
                            print("locality is: \(pm.locality!)")
                            
                            print("number 1")
                            //if pm.locality! == self.myLocality {
                            print("number 2")
                            // print("placemark.count is: \(placemark!.count)")
                            //print("my array is \(self.players)")
                            let player = Player(playerName: snap.childSnapshotForPath("name").value as! String, highscore: snap.childSnapshotForPath("highscore").value as! Int)
                            self.players.append(player)
                            self.tableView.reloadData()
                            
                            //self.loadingLabel.hidden = true
                            
                            // }
                            
                            //print("is: \(pm)")
                            
                        } else {
                            print("Error with data")
                        }
                        
                    })
                    print("you passed it")
                    
                }
            }
            //self.players = self.players.reverse()
            
            
            self.tableView.reloadData()
            //self.loadingLabel.hidden = true
            
        })
    }
    
    func getPickerViewValues() {
        DataService.ds.REF_USERS.childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String).childByAppendingPath("currentLocation").observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.regions[0] = snapshot.childSnapshotForPath("city").value as! String
            self.regions[1] = snapshot.childSnapshotForPath("subAdministrativeArea").value as! String
            self.regions[2] = snapshot.childSnapshotForPath("state").value as! String
            self.regions[3] = snapshot.childSnapshotForPath("country").value as! String
            self.regions[4] = "world"
            
        })
    }
    
    
    
    
}
