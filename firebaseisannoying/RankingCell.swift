//
//  RankingCell.swift
//  LeaderboardPlatform
//
//  Created by Philippe Rivard on 5/3/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var highscoreLabel: UILabel!
    
    var university: University!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(player: Player, number: Int) {
        playerNameLabel.text = player.playerName
        highscoreLabel.text = String(player.highscore)
        rankingLabel.text = String(number + 1)
    }
    
}
