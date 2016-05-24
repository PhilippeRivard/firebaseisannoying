//
//  Player.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/15/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import Foundation

class Player {
    private var _playerName: String
    
    private var _highscore: Int
    
    init(playerName: String, highscore: Int) {
        _playerName = playerName
        _highscore = highscore
    }
    
    var playerName: String {
        return _playerName
    }
    var highscore: Int {
        return _highscore
    }
}