//
//  GameManager.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

class GameManager{
    
    static let shared = GameManager()
    
    var bomb: Bomb?
    var currentPlayer: Player?
    
    var players:[Player]?
    
    private init() {
        
    }
    
    func startGame(playerCount: Int, difficulty: Difficulty = .Medium) {
        
        for playerId in 1...playerCount {
            players?.append(Player(id: playerId, limit: 50.0))
        }
        
        currentPlayer = players?.first
        bomb = Bomb(stabilityLimit: 200.0, timeLimit: 120)
    }
    
    func resetGame() {
        currentPlayer = nil
        players = nil
        bomb = nil
    }
}
