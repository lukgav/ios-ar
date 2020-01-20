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
        
    private var oldMotionData: MotionData = MotionData()
    private var currentMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    private var maxOverallRotRate: Double = 0.05
    private var maxOverallAcc: Double = 0.05
    private var maxRotRate: SIMD3<Double> =  SIMD3<Double>(x: 1.2, y: 1.2, z: 1.2)
    private var maxAcc: SIMD3<Double> =  SIMD3<Double>(x: 1, y: 1, z: 1.5)
    
    private var minGrav: SIMD3<Double> =  SIMD3<Double>(x: -0.5, y: -0.5, z: -0.5)
    private var maxGrav: SIMD3<Double> =  SIMD3<Double>(x: 5, y: 5, z: 4)
    struct errorMsg{
        var outOfRange = "Out of Range "
        var outOfXRange = "Out of X Range "
        var outOfYRange = "Out of Y Range  "
        var outOfZRange = "Out of Z Range  "
        var tooHigh = "past max value"
        var tooHighX = "past max X value"
        var tooHighY = "past max Y value"
        var tooHighZ = "past max Z value"
        var tooLow = "under min value"
        var tooLowX = "under min X value"
        var tooLowY = "under min Y value"
        var tooLowZ = "under min Z value"
    }
    private var errMsg = errorMsg()
    private var turningAwayFromUser: Bool = true
    private var turningClockwise: Bool = true
    
    
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
//            let acc_limit:Double = 5
            
            self.diffMotionData = self.currentMotionData.diff(other: self.oldMotionData)
            self.currentMotionData = self.oldMotionData
            
//
            print("------------------------------------------------------------")
//            print("Last: \(self.oldMotionData.ToString())")
//            print("Diff: \(self.diffMotionData.ToString())")
            
              // ------------ ------------ z-direction ------------ ------------
                    // - x to check direction gravity
                    // - z to check rate of change in gravity of x
                    // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
                 
            
            if( self.isDeviceTurningAway() && self.turningAwayFromUser){
                //check if gravity is out of range in y-direction
                if (self.currentMotionData.isOutOfYRangeOf(motionType: MotionType.gravity, maxValue: self.maxGrav.y, minValue: self.minGrav.y)){
                    self.decreaseBombStabilityAndColor(pErr: MotionType.gravity.toString + self.errMsg.outOfYRange)
                }
                //Check if phone is face up (check if gravity less than 0 z-direction)
                //            if (self.oldMotionData.isUnderMinZValueOf(motionType: MotionType.gravity, minValue: self.minGrav.z)){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooLowZ)
                //            }
                //Check if value has gone over max Accel or rotation rate
                if(self.isOverMaxAcceleration()) {
                    self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooHigh)
                }
                //            if(self.isOverMaxRotationRate()){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.rotation.toString + self.errMsg.tooHigh)
            }

//            }
        }
    }
    
    func stopUnwrapX() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
    }
    
    func decreaseBombStabilityAndColor(pErr: String) -> Bool{
        print(pErr + "\n")
        let result = self.gameManager.bomb?.decreaseStability(percentage: 5.0)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
//        return result
        if (result == false) {
            // bomb exploded, show end screen
            //Trung what does this mean!
//            self.gameManager.loserPlayer
            return false
        }
        return true
    }
    //Does not care about direction of device only whether Gravity is increasing
    
    func whichAxes(pDirection: Direction) -> (Double, Double){
        var current: Double
        var old: Double
        switch pDirection{
        case .x:
            current = self.currentMotionData.gravity.x
            old = self.oldMotionData.gravity.x
        case .y:
            current = self.currentMotionData.gravity.y
            old = self.oldMotionData.gravity.y
        case .z:
            current = self.currentMotionData.gravity.z
            old = self.oldMotionData.gravity.z
        case .all:
            current = self.currentMotionData.gravity.x
            old = self.oldMotionData.gravity.x
        }
        return (current, old)
    }
    func isGravityIncreasingInDirection(pDirection: Direction) -> Bool{
        var current: Double
        var old: Double
        
        (current, old) = whichAxes(pDirection: pDirection)
        
        return current > old
    }
    
    func isDeviceTurningAway() -> Bool{
        return isGravityIncreasingInDirection(pDirection: Direction.x)
    }
    func isDeviceTurningClockwise() -> Bool{
        return isGravityIncreasingInDirection(pDirection: Direction.y)
    }

    func increaseBombStabilityAndColor() -> Bool{
        let result = self.gameManager.bomb?.increaseStability(percentage: 5.0)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.bomb!.currentColor)
//        return result
        if (result == false) {
            // bomb exploded, show end screen
            self.gameManager.loserPlayer = self.gameManager.currentPlayer
            self.unwrapViewController.controller?.navigateToEndScreen()
                    return false
        }
            
        return true
    }
    
    
    func isOutofGravRange() -> Bool{
        return (self.oldMotionData.gravity.y > 0.5 || self.oldMotionData.gravity.y  < -0.5)
    }
    
    func isOverMaxAcceleration() -> Bool {
        // too much acceleration (shaking)
        if (self.oldMotionData.motionContainsHigherAbsoluteValueinXYZDirection(motionType: MotionType.acceleration, maxX: self.maxAcc.x, maxY: self.maxAcc.y, maxZ: self.maxAcc.z)) {
            return true
        }
        else {
            return false
        }
    }
    
    func isOverMaxRotationRate() -> Bool {
        // too fast rotation (speed)
        if (self.oldMotionData.motionContainsHigherAbsoluteValueinXYZDirection(motionType: MotionType.rotation, maxX: self.maxRotRate.x, maxY: self.maxRotRate.y, maxZ: self.maxRotRate.z)) {
            return true
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

    func navigateToEndScreen() {
        let result = dmManager.stopDeviceMotion()
        if (result) {
            unwrapViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
        }
    }
}
