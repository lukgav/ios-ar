//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//
class UnwrapController {
 
    private let unwrapViewController : UnwrapViewController
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
    
    private var lastMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxOverallRotRate: Double = 0.05
    private var maxOverallAcc: Double = 0.05
    private var maxRotRate: SIMD3<Double> =  SIMD3<Double>(x: 0.05, y: 5, z: 4)
    private var maxAcc: SIMD3<Double> =  SIMD3<Double>(x: 0.05, y: 5, z: 4)
    
    private var minGrav: SIMD3<Double> =  SIMD3<Double>(x: -0.5, y: -0.5, z: -0.5)
    private var maxGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.05, y: 5, z: 4)
    
    
    
    init(unwrapViewController: UnwrapViewController) {
        self.unwrapViewController = unwrapViewController
    }
    
    // MARK: - Unwrap Logic
    
    
    
    func StartUnwrapX() {
        
        let curPlayerID: Int! = gameManager.currentPlayer!.id
        
        unwrapViewController.curPlayer.text = String(curPlayerID)
        
    }
    
    
    /// Starting position is when the phone is facing towards the user (x=0,y=-1,z=0)
    func startUnwrapAroundZ() {
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
            
            let acc_limit:Double = 5
            self.lastMotionData = newMotionData
            self.diffMotionData = newMotionData.diff(other: self.lastMotionData)
            
            print("------------------------------------------------------------")
            print("Last: \(self.lastMotionData.ToString())")
            print("Diff: \(self.diffMotionData.ToString())")
            
              // ------------ ------------ z-direction ------------ ------------
                    // - x to check direction gravity
                    // - z to check rate of change in gravity of x
                    // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
                    
            // New Code for accelerometer
            //check all possible errors(Will there be other errors here apart from player errors)
            if( (newMotionData.gravity.y > 0.5 || newMotionData.gravity.y  < -0.5) && newMotionData.acceleration.y > acc_limit){
//                PunishPlayer(pBomb: pBomb, pErrorMsg:  perpendicularDirectionError)
                decreaseStabilityBySetAmount
            }
            else if(pAcc!.z > acc_limit || pAcc!.x > acc_limit){
                PunishPlayer(pBomb: pBomb, pErrorMsg:  tooFastWrongDirectionError)
            }
            
            // Old Code for accelerometer
            //check all possible errors(Will there be other errors here apart from player errors)
            if( (pGrav!.y > 0.5 || pGrav!.y < -0.5) && pAcc!.y > acc_limit){
                PunishPlayer(pBomb: pBomb, pErrorMsg:  perpendicularDirectionError)
            }
            else if(pAcc!.z > acc_limit || pAcc!.x > acc_limit){
                PunishPlayer(pBomb: pBomb, pErrorMsg:  tooFastWrongDirectionError)
            }
            else{
            
            //phone face up (z-grav of phone is in -ve)
            
    //        if(pGrav!.z < 0){
                //clock-wise(twisting away from the user) grav.x becomes positive
                if (pGoClockWise == false){
                    PunishPlayer(pBomb: pBomb, pErrorMsg:  oppositeDirectionError)
                }
                else{
    //                pGrav!.x < pOldGrav!.x &&
                    //is past max rotation speed
                    if (diffZ > max_grav_diff){
                        PunishPlayer(pBomb: pBomb, pErrorMsg:  tooFastCorrectDirectionError)
                    }
                    //Is change within speed of rotation (max_dev) limits?
                    else if (diffZ < max_grav_diff){
                        encouragePlayer()
                    }
                }
            }
                            
            if (self.lastMotionData.isOutOfYRangeOf(motionType: <#T##MotionType#>, maxValue: <#T##Double#>, minValue: <#T##Double#>) && )
            if (self.lastMotionData.isUnderMinZValue(motionType: MotionType.gravity, minValue: self.minGrav.z)){
                if(self.diffMotionData.gravity.z > self.maxGrav.z){
                    self.decreaseBombStabilityAndColor()
                }
                
            }
            
            if(self.isOverMaxAcceleration() && self.isOverMaxRotationRate()) {
                self.decreaseBombStabilityAndColor()
            }
        }
    }
    
    func stopUnwrapX() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
    }
    
    func decreaseBombStabilityAndColor() -> Bool{
        let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
//        return result
        if (result == false) {
            // bomb exploded, show end screen
            return false
        }
            
        return true
    }
    

    func increaseBombStabilityAndColor() -> Bool{
        let result = self.gameManager.bomb?.increaseStability(percentage: 5.0)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
//        return result
        if (result == false) {
            // bomb exploded, show end screen
            return false
        }
            
        return true
    }
    
    
    func isOutofGravRange() -> Bool{
        return (self.lastMotionData.gravity.y > 0.5 || self.lastMotionData.gravity.y  < -0.5)
    }
    
    func isOverMaxAcceleration() -> Bool {
        // too much acceleration (shaking)
        if (self.lastMotionData.accelerationContainsHigherAbsoluteValueinXYZDirection(maxX: self.maxAcc.x, maxY: self.maxAcc.y, maxZ: self.maxAcc.z)) {
            return decreaseBombStabilityAndColor()
        }
        else {
            return false
        }
    }
    
    func isOverMaxRotationRate() -> Bool {
        // too fast rotation (speed)
        if (self.lastMotionData.rotationContainsHigherAbsoluteValueinXYZDirection(maxX: self.maxRotRate.x, maxY: self.maxRotRate.y, maxZ: self.maxRotRate.z)) {
            return decreaseBombStabilityAndColor()
        }
        else {
            return false
        }
    }
    
    // MARK: - Navigation
    
    func navigateToNextTask() {
        //var nextTaskType = gameManager.switchToNextTask()
        
        unwrapViewController.performSegue(withIdentifier: Constants.DeliverSegue, sender: self)
    }
    
    func navigateToHome() {
        let result = dmManager.stopDeviceMotion()
        if (result) {
            unwrapViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }
}
