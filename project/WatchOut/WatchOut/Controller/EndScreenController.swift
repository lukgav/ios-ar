//
//  EndScreenController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class EndScreenController {

    private let endScreenViewController : EndScreenViewController
    
    private let gameManager = GameManager.shared
    private let dmManager = DeviceMotionManager.shared
    
    init(endScreenViewController: EndScreenViewController) {
        self.endScreenViewController = endScreenViewController
    }
        
    // MARK: - Navigation
    
    func showLoserPlayer() {
        var loserPlayer = gameManager.currentPlayer
        
        var newText = String("\(loserPlayer?.name) lost!")
        endScreenViewController.updateLoserLabel(newText: newText)
    }
    
    func navigateToHome() {
        gameManager.endCurrentGame()
        endScreenViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
    }
    
    func navigateToFirstTask() {
        let lastPlayers = gameManager.players
        gameManager.startNewGame(players: lastPlayers)
        
        let result = dmManager.startDeviceMotion()

        if (result) {
            switch(gameManager.currentTask) {
                case .Unwrap:
                    endScreenViewController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
                case .Deliver:
                    endScreenViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
                case .Twitch:
                    endScreenViewController.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
                case .none:
                    return
            }
        }
    }
}
