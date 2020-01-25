//
//  GameManager.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import CoreMotion
import Foundation
import UIKit

class GameManager{
    
    static let shared = GameManager()
    
    private var soundManager = SoundManager.shared
    
    var bomb: Bomb?
    var currentPlayer: Player?
    var players:[Player] = [Player]()
    
    var currentColor: UIColor = UIColor.white
    
    var currentTask: TaskType?
    
    private init() {
        
    }
    
    /// Starts a new game

    func startNewGame(players: [Player], firstTask: TaskType = .Unwrap, difficulty: Difficulty = .Medium) {
        
        self.players = players
        
        currentPlayer = self.players.first
        bomb = Bomb(stabilityLimit: 100.0, timeLimit: 120)
        currentTask = firstTask
        currentColor = UIColor.white
        
        bomb?.stabilityChangedClosure = stabilityChanged
        
        decreaseStability(percentage: 0.0001)
    }
    
    func endCurrentGame() {
        soundManager.stopTickSound()
        soundManager.playBombSound()
    }
    
    func quitCurrentGame() {
        soundManager.stopTickSound()
    }
    
    func createPlayers(playerNames: [String]) -> [Player] {
        var newPlayers = [Player]()
        for playerId in 0...(playerNames.count - 1) {
            newPlayers.append(Player(name: playerNames[playerId], id: playerId+1, limit: 50.0))
        }
        return newPlayers
    }
    
    /// Switches to next Player
    func switchToNextPlayer(nextPlayer: Player) {
        currentPlayer = nextPlayer
    }
    
    /// Switches to next Task and returns it
    func switchToNextTask() -> TaskType {
        switch(currentTask!) {
            case .Unwrap:
                currentTask = TaskType.Deliver
            case .Deliver:
                currentTask = .Unwrap
            case .Twitch:
                currentTask = .Twitch
        }
        return currentTask!
    }
    
    /// Get the next random Player
    func getNextRandomPlayer() -> Player {
        var nextPlayer: Player
        
        if players.count == 1 {
            return currentPlayer!
        }
        else {
            repeat {
                nextPlayer = players[Int.random(in: 0...players.count-1)]
            } while nextPlayer.id == self.currentPlayer!.id
            
            return nextPlayer
        }
    }
    

    /// Starts the bomb timer
    func startBombTimer() {
        // only start a new timer if none exists
        guard bomb!.timer == nil else { return }
        
        bomb!.timer = Timer.scheduledTimer(withTimeInterval: bomb!.timeInterval, repeats: true) { timer in
            // add time to currentTime every 1/50 secs (timeInterval)
            self.bomb!.currentTime += self.bomb!.timeInterval
        }
    }
    
    /// Stops the bomb timer
    func stopBombTimer() {
        // delete the old timer object and create a new one
        // when the timer should start counting again
        bomb!.timer?.invalidate()
        bomb!.timer = nil
    }
        
    /// Returns true, if the bomb exlodes after decreasing the stability
    func decreaseStability(percentage: Double) -> Bool{
        bomb!.stabilityCounter -= percentage*bomb!.stabilityLimit
        
        if (bomb!.stabilityCounter < 0.0) {
            return true
        }
        return false
    }
    
    /// If the added percentage is higher than the StabilityLimit, it will only increase to the StabilityLimit
    func increaseStability(percentage: Double) {
        let increaseAmount = percentage*bomb!.stabilityLimit
        
        // only increase to a maximum of the stabilyLimit
        if(bomb!.stabilityCounter + increaseAmount >= bomb!.stabilityLimit) {
            bomb?.stabilityCounter = bomb!.stabilityLimit
        }
        else {
            bomb?.stabilityCounter += increaseAmount
        }
    }
    
    /// Returns false, if the bomb explodes when setting the new percentage
    /// percentage should be between 0.0 and 1.0
    func setStability(percentage: Double) -> Bool {
        if (percentage > 0.0 && percentage < 1.0) {
            let newStability = percentage*bomb!.stabilityLimit
            bomb!.stabilityCounter = newStability
            
            return true
        }
        
        return false
    }
    
    /// Updates hasExploded, currentColor and tickSound
    private func stabilityChanged() {
        // alpha = 0.0 should be white, alpha = 1.0 should be red
        if (bomb!.stabilityCounter < 0.0) {
            bomb!.hasExploded = true
        }
        
        // begins with 0.0, ends with 1.0
        let progressPercentage = bomb!.stabilityCounter/bomb!.stabilityLimit
                
        if (progressPercentage >= 0.0 && progressPercentage <= 1.0) {
            
            // Color
            let newRed = CGFloat(255/255)
            let newGreen = CGFloat(progressPercentage)
            let newBlue = CGFloat(progressPercentage)
            
            currentColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
            print("Color: \(currentColor)")
            
            // Tick Sound
            
            soundManager.playTickSound(newUpdateInterval: 2.5*progressPercentage)
        }
    }
}
