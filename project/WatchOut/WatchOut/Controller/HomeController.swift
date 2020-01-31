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
    private var currentLightIntensity: Double?

    //Timer variables
    private var timer: Timer
    // Time is in seconds
    private let timeInterval: Double = 1
    private var waitTime: Double?
    private var coverLightOnce = false
    private var tappedLight = false
    private var coverLightTwice = false
    private var doubleTappedLight = false
    private var _maxIntensity: Double?
    private var _minIntensity: Double?
    
    var playerCount: Int = 2
    
    let homeViewController : HomeViewController
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        timer = Timer()
        _maxIntensity = 1000
        _minIntensity = 750
    }
    
    func checkifTapped(totalDuration: Double){
        waitTime = totalDuration
        timer = Timer.scheduledTimer(withTimeInterval:self.timeInterval, repeats: true){timer in
            
            self.waitTime! -= self.timeInterval
//            print("IN TIMER")
            print("---------------------------------------------")
            print("Was Light: \(!self.isAmbientIntensityDark)")
            print("Is Dark: \(self.isLightCurrentlyOff())")
            print("Tapped Light: \(self.tappedLight)")
            print ("IS True: \(!self.isAmbientIntensityDark && self.isLightCurrentlyOff() && self.tappedLight)")
            if (self.doubleTappedLight){
                self.playerCount += 1
            }

            if (self.waitTime! < 0.0) {
                print("--------------------------------Timer is FINISHED--------------------------------")
                timer.invalidate()
                // Timer ran out
            }
            if (self.isAmbientIntensityDark && self.isLightCurrentlyOn() && self.coverLightTwice) {
                    self.isAmbientIntensityDark = false
                    print("Light sensor has been TAPPED TWICE")
            }
            if (self.isAmbientIntensityDark && self.isLightCurrentlyOn()) {
                    self.isAmbientIntensityDark = false
                    self.tappedLight = true
                    print("Light sensor has been TAPPED ONCE")
            }
            if(!self.isAmbientIntensityDark && self.isLightCurrentlyOff() && self.tappedLight){
                print("!!!!!!!!!!!!!Light sensor COVERED TWICE!!!!!!!!!!!!!!")

                self.isAmbientIntensityDark = true
                self.coverLightTwice = true
//                print("Light sensor COVERED TWICE")
            }
                
                //print("CountDownTime: \(self.countDownTime)")
//                self.deliverViewController.updateTimerLabel(newTime: self.countDownTime)
            
            
            return
        }
    }
    
    func isLightCurrentlyOn()->Bool{
        return self.currentLightIntensity! > _maxIntensity!
    }
    func isLightCurrentlyOff()->Bool{
        return self.currentLightIntensity! < self._minIntensity!
    }
    
    func ambientLightOn(maxIntensity: Double, minIntensity: Double){
        let isLightSensorOn = lsManager.startLightSensor()
        if(isLightSensorOn) {
            print("-----------homescreen: LIGHT sensor ON----------")
            lsManager.ambientIntensity.addObserver(ambientIntensityObserver) { newIntensity in
                self.currentLightIntensity = newIntensity
                // Ignore first values, because of light change on beginning
                if (self.ignoreLightCounter > self.ignoreLightCount) {
//                    print("Intensity: \(newIntensity)")
                    if (self.isAmbientIntensityDark == false && newIntensity < minIntensity && !self.coverLightOnce) {
                        self.isAmbientIntensityDark = true
                        self.coverLightOnce = true
                        // user has thumb on light sensor
                        self.checkifTapped(totalDuration: 10)
                        print("THUMB NOW ON SENSOR")
                   }
//                   else if (self.isAmbientIntensityDark == true && newIntensity > maxIntensity) {
//                       self.isAmbientIntensityDark = false
//                       // user lifted thumb and delivered to next player
//                        print("THUMB LEFT THE SENSOR")
//                        isLightSensorOn = self.lsManager.stopLightSensor()
//                        self.navigateToFirstTask()
//                   }
                }
                else {
                        print("Ignored Intensity: \(newIntensity)")
                        self.ignoreLightCounter += 1
                }
            }
        }
    }
    
    func startGame(){
        self.ambientLightOn(maxIntensity: _maxIntensity!, minIntensity: _minIntensity!)
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
