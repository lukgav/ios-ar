//
//  HomeController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class HomeController {
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
    
    

    var playerCount: Int = 1
    
    let homeViewController : HomeViewController
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }
    
    // MARK: - Navigation
    
    func navigateToFirstTask() {
        // create dummy player names
        var playerNames: [String] = [String]()
        for i in 0...playerCount {
            playerNames.append(String("Player \(i)"))
        }
        
        var players = gameManager.createPlayers(playerNames: playerNames)
        
        gameManager.startNewGame(players: players)
        let result = dmManager.startDeviceMotion()

        if (result) {
            switch(gameManager.currentTask) {
                case .Unwrap:
                    homeViewController.performSegue(withIdentifier: Constants.UnwrapSegue, sender: self)
                case .Deliver:
                    homeViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
                case .Twitch:
                    homeViewController.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
                case .none:
                    return
            }
        }
    }
    
    func navigateToHelp() {
        homeViewController.performSegue(withIdentifier: Constants.HelpSegue, sender: self)
    }
}
