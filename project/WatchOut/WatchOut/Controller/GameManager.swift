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
    var players:[Player]?
    var leftPlayers:[Player]?
    
    var currentTask: TaskType?
    
    private init() {
        
    }
    
    /// Starts a new game
    func startNewGame(playerNames:[String], playerCount: Int, firstTask: TaskType = .Unwrap, difficulty: Difficulty = .Medium) {
        
        for playerId in 1...playerCount {
            for playerName in playerNames {
                players?.append(Player(name: playerName, id: playerId, limit: 50.0))
            }
        }
        
        loserPlayer = nil
        leftPlayers = players
        currentPlayer = players?.first
        bomb = Bomb(stabilityLimit: 200.0, timeLimit: 120)
        currentTask = firstTask
        
        
    }
    
    /// Resets the current game
    func resetGame() {
        currentPlayer = nil
        players = nil
        bomb = nil
        currentTask = nil
    }
    
    /// Switches to next Player
    func switchToNextPlayer() {
        guard let currentIndex = players?.firstIndex(where: {$0 === currentPlayer})! else  {
            return
        }
        if (currentIndex + 1 >= players!.count) {
            currentPlayer = players![0]
        }
        else
        {
            currentPlayer = players![currentIndex+1]
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
    func getNextPlayer() -> Player {
<<<<<<< HEAD
        let sumPlayer = self.leftPlayers?.count
        //var randomNextPlayer = players!.firstIndex(where: {$0.id == self.currentPlayer?.id})
        var nextPlayer: Player?
        while (nextPlayer!.id == self.currentPlayer!.id) {
            nextPlayer = leftPlayers![Int.random(in: 0...sumPlayer!)]
        }
        var nextPlayerIndex : Int? = leftPlayers!.firstIndex(where: {$0.id == nextPlayer!.id})
        leftPlayers!.remove(at: nextPlayerIndex!)
        return nextPlayer!
=======
        var lPlayer = Player(id: 3, limit: 100)
        return lPlayer
>>>>>>> 9e20312f94628a257e47405d99933eeda399e454
    }
}
