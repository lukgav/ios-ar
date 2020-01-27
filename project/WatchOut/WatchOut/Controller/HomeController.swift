//
//  HomeController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import Foundation

class HomeController {
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
    
    //AmbientLight sensor variables
    private let lsManager = LightSensorManager.shared
    private let ambientIntensityObserver = AmbientIntensityObserver()
    
    private var ignoreLightCounter: Int = 0
    private let ignoreLightCount: Int = 2
    private var isAmbientIntensityDark: Bool = false

    private var timer: Timer
    
    var playerCount: Int = 2
    
    let homeViewController : HomeViewController
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        timer = Timer()
    }
    
    func ambientLightOn(maxIntensity: Double, minIntensity: Double){
        var isLightSensorOn = lsManager.startLightSensor()
        if(isLightSensorOn) {
            print("-----------homescreen: LIGHT sensor ON----------")
            lsManager.ambientIntensity.addObserver(ambientIntensityObserver) { newIntensity in
                // Ignore first values, because of light change on beginning
                if (self.ignoreLightCounter > self.ignoreLightCount) {
                    print("Intensity: \(newIntensity)")
                    if (self.isAmbientIntensityDark == false && newIntensity < minIntensity) {
                        self.isAmbientIntensityDark = true
                        // user has thumb on light sensor
                        print("THUMB NOW ON SENSOR")
                   }
                   else if (self.isAmbientIntensityDark == true && newIntensity > maxIntensity) {
                       self.isAmbientIntensityDark = false
                       // user lifted thumb and delivered to next player
                        print("THUMB LEFT THE SENSOR")
                        isLightSensorOn = self.lsManager.stopLightSensor()
                        self.navigateToFirstTask()
                   }
                }
                else {
                        print("Ignored Intensity: \(newIntensity)")
                        self.ignoreLightCounter += 1
                }
            }
        }
    }
    
    func startGame(){
//        self.ambientLightOn(maxIntensity: 1000, minIntensity: 750)
//        {
//            navigateToFirstTask()
//        }
    }
    
    
    // MARK: - Navigation
    
    func navigateToFirstTask() {
        // create dummy player names
        var playerNames: [String] = [String]()
        for i in 0...playerCount {
            playerNames.append(String("Player \(i)"))
        }
        
        let players = gameManager.createPlayers(playerNames: playerNames)
        
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
