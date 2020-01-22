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
    var loserPlayer: Player?
    var players:[Player] = [Player]()
    
    var currentTask: TaskType?
    
    private init() {
        
    }
    
    /// Starts a new game
    func startNewGame(playerNames:[String], playerCount: Int, firstTask: TaskType = .Unwrap, difficulty: Difficulty = .Medium) {
        
        for playerId in 1...playerCount {
            for playerName in playerNames {
                players.append(Player(name: playerName, id: playerId, limit: 50.0))
            }
        }
        
        loserPlayer = nil
        currentPlayer = players.first
        bomb = Bomb(stabilityLimit: 200.0, timeLimit: 120)
        currentTask = firstTask
    }
    
    /// Resets the current game
    func resetGame() {
        currentPlayer = nil
        players = [Player]()
        bomb = nil
        currentTask = nil
    }
    
    /// Switches to next Player
    func switchToNextPlayer() {
        let currentIndex = players.firstIndex(where: {$0 === currentPlayer})!
        
        if (currentIndex + 1 >= players.count) {
            currentPlayer = players[0]
        }
        else
        {
            currentPlayer = players[currentIndex+1]
        }
    }
    
    /// Switches to next Task and returns it
    func switchToNextTask() -> TaskType {
        switch(currentTask!) {
            case .Unwrap:
                currentTask = TaskType.Deliver
            case .Deliver:
                currentTask = .Unwrap
        }
        return currentTask!
    }
    
    // get the next random Player
    func getNextRandomPlayer() -> Player {
        var nextPlayer: Player
        
        repeat {
            nextPlayer = players[Int.random(in: 0...players.count-1)]
        } while nextPlayer.id == self.currentPlayer!.id
        
        return nextPlayer
    }
}
