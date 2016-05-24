//
//  DataService.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/12/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://leaderboardplatform.firebaseio.com")
    private var _REF_USERS = Firebase(url: "https://leaderboardplatform.firebaseio.com/users")
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    var REF_USERS:Firebase {
        return _REF_USERS
    }
}