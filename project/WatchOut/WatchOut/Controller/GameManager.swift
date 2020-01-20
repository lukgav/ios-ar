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
    
    var currentTask: TaskType?
    
    private init() {
        
    }
    
    /// Starts a new game
    func startNewGame(playerCount: Int, firstTask: TaskType = .Unwrap, difficulty: Difficulty = .Medium) {
        
        for playerId in 1...playerCount {
            players?.append(Player(id: playerId, limit: 50.0))
        }
        
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
    
    func getNextPlayer() -> Player {
        var sumPlayer = self.players?.count
        var randomNextPlayer = players!.firstIndex(where: $)
        while (randomNextPlayer.id == self.currentPlayer.id) {
            
        }
    }
}
