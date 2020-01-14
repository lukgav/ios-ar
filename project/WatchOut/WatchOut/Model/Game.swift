//
//  Game.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class Game {
    
    var players: Array<Player>
    var bombLimit: Double
    
    
    init(playerCount: Int) {
        players = Array<Player>()
        for playerId in 1...playerCount {
            players.append(Player(id: playerId, limit: 0.0))
        }
        
        bombLimit = Double(players.count)*100.0
    }
    
    
}
