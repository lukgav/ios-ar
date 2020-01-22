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
    private var maxGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.3, y: 0.3, z: 0.7)
    
    private var maxGravDiff: SIMD3<Double> =  SIMD3<Double>(x: 0.2, y: 0.2, z: 0.2)

    
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
    private var shouldTurnAwayFromUser: Bool = true
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
    func startUnwrapAroundZ(){
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
//            let acc_limit:Double = 5
            self.currentMotionData = newMotionData
//            self.diffMotionData = self.currentMotionData.diff(other: self.oldMotionData)
//            self.currentMotionData = self.oldMotionData
            
//
            print("------------------------------------------------------------")
//            print("Last: \(self.oldMotionData.ToString())")
            print("newGravX: \(newMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("oldDiffGravX: \(self.diffMotionData.gravity.x)")
            
              // ------------ ------------ z-direction ------------ ------------
                    // - x in gravity to check direction of movement
                    // - z to check rate of change in gravity of x
                    // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
                 
            if(self.isDeviceTurningInCorrectDirection()){
                //check if gravity is out of range in y-direction
                print("Going in right direction")
                if (self.currentMotionData.isOutOfYRangeOf(motionType: MotionType.gravity, maxValue: self.maxGrav.y, minValue: self.minGrav.y)){
                    self.decreaseBombStabilityAndColor(pErr: MotionType.gravity.toString + self.errMsg.outOfYRange)
                    return
                }
                //Check if phone is face up (check if gravity less than 0 z-direction)
                //            if (self.oldMotionData.isUnderMinZValueOf(motionType: MotionType.gravity, minValue: self.minGrav.z)){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooLowZ)
                //            }
                //Check if value has gone over max Accel or rotation rate
                if(self.isOverMaxAcceleration()) {
                    self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooHigh)
                    return
                }
                //            if(self.isOverMaxRotationRate()){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.rotation.toString + self.errMsg.tooHigh)
            }
            else{
                self.decreaseBombStabilityAndColor(pErr: "Going in wrong direction")
                return
            }
//            }
        }
        return
    }
    
    func isDeviceTurningInCorrectDirection() -> Bool{
        return (self.isDeviceTurningAway() && self.shouldTurnAwayFromUser)
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
    
    func whichAxes(pDirection: Direction) -> (Double, Double, Double){
        var current: Double
        var old: Double
        var diff: Double
        
        switch pDirection{
        case .x:
            current = self.currentMotionData.gravity.x
            old = self.oldMotionData.gravity.x
            diff = self.diffMotionData.gravity.x
        case .y:
            current = self.currentMotionData.gravity.y
            old = self.oldMotionData.gravity.y
            diff = self.diffMotionData.gravity.y
        case .z:
            current = self.currentMotionData.gravity.z
            old = self.oldMotionData.gravity.z
            diff = self.diffMotionData.gravity.z

        case .all:
            current = self.currentMotionData.gravity.x
            old = self.oldMotionData.gravity.x
            diff = self.diffMotionData.gravity.x
        }
        return (current, old, diff)
    }
    func isGravityIncreasingInDirection(pDirection: Direction) -> Bool{
        var current: Double
        var old: Double
        var diff: Double
        var diffTotal: Double
        (current, old, diffTotal) = whichAxes(pDirection: pDirection)
        
        diff =  abs(current - old)
        
        return (diff > maxGravDiff.x || diff == 0.0)
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
            self.unwrapViewController.controller?.navigateToEndScreen()
                    return false
        }
        return true
    }
    
    func isOutofGravRange() -> Bool{
        return (self.oldMotionData.gravity.y > 0.5 || self.oldMotionData.gravity.y  < -0.5)
    }
    
    func isOverMaxChangeInGravityinDirection(pDirection: Direction) -> Bool{
        
        var (current, old, diff): (Double, Double, Double)
        
        (current, old, diff) = whichAxes(pDirection: pDirection)
        
        return diff < self.maxGrav.x
    }
    
    func isOverMaxAcceleration() -> Bool {
        // too much acceleration (shaking)
        if (self.oldMotionData.motionContainsHigherAbsoluteValueinXYZDirection(motionType: MotionType.acceleration, maxX: self.maxAcc.x, maxY: self.maxAcc.y, maxZ: self.maxAcc.z)) {
            return true
        }
        return false
    }
    
    func isOverMaxRotationRate() -> Bool {
        // too fast rotation (speed)
        if (self.oldMotionData.motionContainsHigherAbsoluteValueinXYZDirection(motionType: MotionType.rotation, maxX: self.maxRotRate.x, maxY: self.maxRotRate.y, maxZ: self.maxRotRate.z)) {
            return true
        }
        return false
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
