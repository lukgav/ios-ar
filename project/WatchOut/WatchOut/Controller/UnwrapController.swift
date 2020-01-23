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
    
    private var minGrav: SIMD3<Double> =  SIMD3<Double>(x: -0.2, y: -0.2, z: -0.2)
    private var maxGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.2, y: 0.2, z: 0.2)
    
    private var maxGravDiff: SIMD3<Double> =  SIMD3<Double>(x: 0.3, y: 0.3, z: 0.3)
    private var minGravDiff: SIMD3<Double> =  SIMD3<Double>(x: 0.1, y: 0.1, z: 0.1)

    
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
//            print("newGravX: \(newMotionData.gravity.x)")
            self.currentMotionData = newMotionData
//            print("currentGravX: \(self.currentMotionData.gravity.x)")
//            print("oldGravX: \(self.oldMotionData.gravity.x)")
            self.diffMotionData = self.currentMotionData.diff(other: self.oldMotionData)
//            print("DiffGravX: \(self.diffMotionData.gravity.x)")
//            print("currentGravZ: \(self.currentMotionData.gravity.z)")
//            print("currentGravY: \(self.currentMotionData.gravity.y)")

            
//
//            print("------------------------------------------------------------")
//            print("Last: \(self.oldMotionData.ToString())")
//            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            
              // ------------ ------------ z-direction ------------ ------------
                    // - x in gravity to check direction of movement
                    // - z to check rate of change in gravity of x
                    // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
//            self.checkBombExplode()
            self.checkUnwrapMotion()
            //Update oldMotionData. Do here AFTER all computation is done
            self.oldMotionData = self.currentMotionData

        }
        return
    }
    
    
    
    func isDeviceTurningInCorrectDirection() -> Bool{
        
        if(self.isDeviceTurningAwayFromUser() && self.shouldTurnAwayFromUser){
            return true
        }
        else if(!self.isDeviceTurningAwayFromUser() && !self.shouldTurnAwayFromUser){
            return true
        }
        else{
            return false
        }
    }
    
//    func stopUnwrapX() {
//        print("stop")
//        dmManager.newMotionData.removeObserver(observer)
//    }
    
    func stopUnwrap() {
        print("stop")
        dmManager.currentMotionData.removeObserver(observer)
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
//        print("current: \(current),old: \(old),diff: \(diff) \n")
        return (current, old, diff)
    }
    
    func isGravityIncreasingInDirection(pDirection: Direction) -> Bool{
        var current: Double
        var old: Double
        var diffDir: Double
        var diffTotal: Double
        (current, old, diffTotal) = whichAxes(pDirection: pDirection)
        
        diffDir =  abs(current - old)
        return current > old
//        return diffTotal >= 0
    }
    
    func isWithinRange(val: Double,min: Double,max: Double) ->Bool{
        return (val < max) && (val > min)
    }
    func isGravZNeg() -> Bool{
        return self.currentMotionData.gravity.z < 0.0
    }
    func isGravZPos() -> Bool{
        return self.currentMotionData.gravity.z > 0.0
    }
    
//    func isOverMaxChangeInGravityinDirection(pDirection: Direction) -> Bool{
//        var (current, old, diff): (Double, Double, Double)
//
//        (current, old, diff) = whichAxes(pDirection: pDirection)
//
//        return diff > self.maxGrav.x
//    }
    func isGravityIncreasingInXDirection() -> Bool{
        return self.currentMotionData.gravity.x > self.oldMotionData.gravity.x
    }
    
    
    
    func isGravityDecreasingInXDirection() -> Bool{
        return self.currentMotionData.gravity.x < self.oldMotionData.gravity.x
    }
    
    func checkUnwrapMotion(){
        if(self.isDeviceTurningInCorrectDirection()){
                //check if gravity is out of range in y-direction
        //                print("Going in right direction")
                self.checkGravYPosition()
                self.checkChangeinGrav()
            }
        else{
            self.decreaseBombStabilityAndColor(pDmg: 5.0, pErr: "Going in wrong direction")
        }
    }

    func checkChangeinGrav(){
        //X Direction
        checkDiffGravinDirection(val: self.diffMotionData.gravity.x, minVal: self.minGrav.x, maxVal: self.maxGrav.x)
        //Z direction
        checkDiffGravinDirection(val: self.diffMotionData.gravity.z, minVal: self.minGrav.z, maxVal: self.maxGrav.z)
        //Y Direction
        checkDiffGravinDirection(val: self.diffMotionData.gravity.y, minVal: self.minGrav.y, maxVal: self.maxGrav.y)
    }
    func checkDiffGravinDirection(val: Double, minVal: Double, maxVal: Double){
        if(val > maxVal){
            decreaseBombStabilityAndColor(pDmg: 5.0, pErr: "Over max change in gravity ")
        }
        else if(isWithinRange(val: val, min: minVal ,max: maxVal)){
            var lDmg: Double
            lDmg = 0.5 * val
            decreaseBombStabilityAndColor(pDmg: lDmg, pErr: "Over max change in gravity ")
        }
    }
    
    func checkGravYPosition(){
        if (self.currentMotionData.isOutOfYRangeOf(motionType: MotionType.gravity, maxValue: self.maxGrav.y, minValue: self.minGrav.y)){
            self.decreaseBombStabilityAndColor(pDmg: 5.0,pErr: MotionType.gravity.toString + self.errMsg.outOfYRange)
            return
        }
    }
    
    func isOutofGravYRange() -> Bool{
        return !isWithinRange(val: self.oldMotionData.gravity.y, min: self.minGrav.y, max: self.maxGrav.y)
    }
    
    func isDeviceTurningAwayFromUser() -> Bool{
        if(isGravityIncreasingInDirection(pDirection: Direction.x) && isGravZNeg()){
//            print("Grav is INCREASING")
            return true
        }
        else if(!isGravityIncreasingInDirection(pDirection: Direction.x) && isGravZPos()){
//            print("Grav is DECREASING")
            return true
        }
        else{
            return false
        }
    }
    
    func isDeviceTurningClockwise() -> Bool{
        return isGravityIncreasingInDirection(pDirection: Direction.y)
    }

    func checkBombExplode(){
        if(self.gameManager.decreaseStability(percentage: 0.0)){
            self.navigateToEndScreen()
        }
    }
    func decreaseBombStabilityAndColor(pDmg: Double, pErr: String){
        print(pErr + "\n")
        self.gameManager.decreaseStability(percentage: pDmg)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.currentColor)
    }
    
    func increaseBombStabilityAndColor(){
        self.gameManager.increaseStability(percentage: 5.0)
        self.unwrapViewController.updateBackgroundColor(color: self.gameManager.currentColor)
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

        unwrapViewController.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
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



/// OLD CODE for Unwrap function

                //Check if phone is face up (check if gravity less than 0 z-direction)
                //            if (self.oldMotionData.isUnderMinZValueOf(motionType: MotionType.gravity, minValue: self.minGrav.z)){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooLowZ)
                //            }
                ///Check if value has gone over max chaneg in Grav
//                if(self.isOverMaxChangeInGravityinDirection(pDirection: Direction.z)){
//                    self.decreaseBombStabilityAndColor(pErr: MotionType.gravity.toString + self.errMsg.tooHigh)
//                }
                ///Check if value has gone over max Accel or rotation rate
//                if(self.isOverMaxAcceleration()) {
//                    self.decreaseBombStabilityAndColor(pErr: MotionType.acceleration.toString + self.errMsg.tooHigh)
//                    return
//                }
                //            if(self.isOverMaxRotationRate()){
                //                self.decreaseBombStabilityAndColor(pErr: MotionType.rotation.toString + self.errMsg.tooHigh)
