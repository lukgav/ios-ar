//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//
import Foundation

class UnwrapController {
 
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
    
    //---------------------Values currently set for Going in X direction---------------------
    private var minGrav: SIMD3<Double> =  SIMD3<Double>(x: -0.2, y: -0.2, z: -0.2)
    private var maxGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.2, y: 0.2, z: 0.2)
    private var topMaxDiffGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.4, y: 0.4, z: 0.4)
    private var bottomMaxDiffGrav: SIMD3<Double> =  SIMD3<Double>(x: 0.15, y: 0.15, z: 0.15)
    //---------------------Values currently set for Going in X direction---------------------

    private var maxNumTurns: Int = 0
    private var turnCounter: Int = 0
    
    private var errMsg = errorMsg()
    private var shouldTurnClockwise: Bool = true
    private let dmgVal: Double = 0.05
    
    init(unwrapViewController: UnwrapViewController) {
        self.unwrapViewController = unwrapViewController
        self.maxNumTurns = 2
//        self.getRandomTurns()
    }
    // MARK: - Unwrap Logic

    func getRandomTurns(){
        self.maxNumTurns = Int.random(in: 0...3)
    }
    func getRandomDirection(){
        self.shouldTurnClockwise = Bool.random()
//            Int.random(in: 0...3)
    }
    func getRandomCoOrd()->Direction{
//        var val =
        return Direction.z
    }
    
    /// Starting position is when the phone is facing towards the user (x=0,y=-1,z=0)
    func startUnwrap(){
        let lDirection: Direction =  .z
        self.loadUI()
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
            self.loadNewData(pNewMotionData: newMotionData)
            self.checkTaskFinishedCondition()
            self.prinGravtData(pDirection: lDirection)
            /// Players mistakes and consequences are checked below
//            self.checkBombExplode()
//            self.UnwrapInDirection(pDirection: lDirection)
            ///Update oldMotionData and background color. Do here AFTER all computation is done
            self.oldMotionData = self.currentMotionData
            self.unwrapViewController.updateBackgroundColor(pColor: self.gameManager.currentColor)
        }
        return
    }
    
    func loadUI(){
        let nextPlayer =  gameManager.getNextRandomPlayer()
        
        unwrapViewController.updatePlayerNameLabel(name: nextPlayer.name)
        unwrapViewController.updateBackgroundColor(pColor: gameManager.currentColor)
        // TODO: randomize direction AND clockWise Boolean
        unwrapViewController.updateTurningImage(direction: Direction.z, goClockwise: self.shouldTurnClockwise)
        
    }
    
    func loadNewData(pNewMotionData: MotionData){
        self.currentMotionData = pNewMotionData
        self.diffMotionData = self.currentMotionData.diff(other: self.oldMotionData)
    }
    func checkTaskFinishedCondition(){
        self.numOfTurnsMoved()
        self.checkifTaskisFinished()
    }
    
    func printMotionData(pMotionType: MotionType) -> MotionType{
        switch pMotionType{
        case .acceleration:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        case .attitude:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        case .gravity:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        case .rotationrate:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        }
    }
    
    func printData(pDirection: Direction, pMotion: SIMD3<Double>){
        switch pDirection{
        case .x:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        case .y:
            print("---------------------------------------------------")
            print("oldGravY: \(self.oldMotionData.gravity.y)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
            print("DiffGravY: \(self.diffMotionData.gravity.y)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
        case .z:
            print("---------------------------------------------------")
            print("oldGravZ: \(self.oldMotionData.gravity.z)")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("DiffGravZ: \(self.diffMotionData.gravity.z)")
            print("-------------")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
        }
    }
    
    func printGravData(pDirection: Direction){
        switch pDirection{
        case .x:
            print("---------------------------------------------------")
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
        case .y:
            print("---------------------------------------------------")
            print("oldGravY: \(self.oldMotionData.gravity.y)")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
            print("DiffGravY: \(self.diffMotionData.gravity.y)")
            print("-------------")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
        case .z:
            print("---------------------------------------------------")
            print("oldGravZ: \(self.oldMotionData.gravity.z)")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
            print("DiffGravZ: \(self.diffMotionData.gravity.z)")
            print("-------------")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
        }
    }
    
        

    
    func checkUnwrapMotion(){
        ///Works in x direction
//        UnwrapInDirection(pDirection: .x)//        checkUnwrapInYDirection()
        /// DOES NOT WORK IN Y Direction
//        UnwrapInDirection(pDirection: .y)
        /// DOES NOT WORK IN Z Direction
//        UnwrapInDirection(pDirection: .z)
    }
    
    func UnwrapInDirection(pDirection: Direction){
        switch pDirection{
        case .x:
            //This orientation works!
            self.checkUnwrapInDirection(pTurningDir: .x, pStateDir: .z, pWobbleDir: .y)
        case .z:
            //Need to check these values to make sure if this the correct orientation
            self.checkUnwrapInDirection(pTurningDir: .z, pStateDir: .x, pWobbleDir: .y)
        case .y:
            //Need to check these values to make sure if this the correct orientation
            self.checkUnwrapInDirection(pTurningDir: .y, pStateDir: .z, pWobbleDir: .x)
        }
    }
    
    func checkUnwrapInDirection(pTurningDir: Direction, pStateDir: Direction, pWobbleDir: Direction){
        // ------------ ------------ z-direction ------------ ------------
        // - x in gravity to check direction of movement
        // - z to check rate of change in gravity of x
        // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
            
        if(self.isDeviceTurningInCorrectDirection(pTurningDirection: pTurningDir, pStateDirection: pStateDir)){
                //check if gravity is out of range in y-direction
        //                print("Going in right direction")
            self.checkGravPosition(pDirection: pWobbleDir)
            self.checkChangeinGrav()
        }
        else{
            self.decreaseBombStabilityAndColor(pDmg: self.dmgVal, pErr: "Going in wrong direction")
        }
    }
    
    


    
    func numOfTurnsMoved(){
        if(self.currentMotionData.gravity.z >= 0.999){
            turnCounter += 1
        }
    }
    func checkifTaskisFinished(){
        // + 1
        if (turnCounter >= maxNumTurns + 1){
            print("Good job! Task is finished! ")
//            self.navigateToNextTask()
        }
    }
    
    func isDeviceTurningInCorrectDirection(pTurningDirection: Direction, pStateDirection: Direction) -> Bool{
        var isGoinginIntendedDirection: Bool = false
        print("--------------ShouldGoClockwise: \(self.shouldTurnClockwise)--------")
        if(self.isDeviceTurningClockwise(turningDirection: pTurningDirection, stateDirection: pStateDirection) && self.shouldTurnClockwise){
            print("-----------------Turning clockwise-----------------")
            return true
        }
        //OR Is device turning anticlockwise and should it be turning anticlockwise?
        else if(!self.isDeviceTurningClockwise(turningDirection: pTurningDirection, stateDirection: pStateDirection) && !self.shouldTurnClockwise){
            print("-----------------Turning anticlockwise-----------------")
            return true
        }
        else{
            return false
        }
        return isGoinginIntendedDirection
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
    
    func whichGravAxes(pDirection: Direction) -> (Double, Double, Double){
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
//        print("current: \(current),old: \(old),diff: \(diff) \n")
        }
        current =  self.roundtoThousandth(pNum: current)
        old =  self.roundtoThousandth(pNum: old)
        diff =  self.roundtoThousandth(pNum: diff)
        
        return (current, old, diff)
    }
    
    func isGravityIncreasingInDirection(pDirection: Direction) -> Bool{
        var current: Double
        var old: Double
        var diffDir: Double
        var diffTotal: Double
        (current, old, diffTotal) = whichGravAxes(pDirection: pDirection)
        
        diffDir =  abs(current - old)
//        diffTotal = abs(diffTotal)
//        print(diffTotal)
        return current >= old
//        return diffTotal >= 0.0
    }
    
    func roundtoThousandth(pNum: Double)->Double{
        return round(100*pNum) / 100
    }
    
    func isWithinRange(val: Double,min: Double,max: Double) ->Bool{
        return (val < max) && (val > min)
    }

    func checkChangeinGrav(){
        //X Direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.x, minVal: self.bottomMaxDiffGrav.x, maxVal: self.topMaxDiffGrav.x)
        //Z direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.z, minVal: self.bottomMaxDiffGrav.z, maxVal: self.topMaxDiffGrav.z)
        //Y Direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.y, minVal: self.bottomMaxDiffGrav.y, maxVal: self.topMaxDiffGrav.y)
    }
    
    func checkChangeinGravinDirection(val: Double, minVal: Double, maxVal: Double){
        if(val > maxVal){
            decreaseBombStabilityAndColor(pDmg: self.dmgVal, pErr: "Over max change in gravity ")
        }
        else if(isWithinRange(val: val, min: minVal ,max: maxVal)){
            var lDmg: Double
            lDmg = (self.dmgVal/10) * val
            decreaseBombStabilityAndColor(pDmg: lDmg, pErr: "Too much Change in gravity ")
        }
    }
    
    func checkGravPosition(pDirection: Direction)-> Bool{
        let curMotion = self.currentMotionData
        if(curMotion.isOutOfRangeInDirection(pMotion: curMotion.gravity, pDirection: pDirection, maxValue: self.maxGrav.y, minValue: self.minGrav.y)){
            decreaseBombStabilityAndColor(pDmg: self.dmgVal, pErr: MotionType.gravity.toString + ": " +  self.errMsg.outOfRange + "in " + pDirection.toString)
            return true
        }
        return false
    }
    
    func isOutofGravYRange() -> Bool{
        return !isWithinRange(val: self.oldMotionData.gravity.y, min: self.minGrav.y, max: self.maxGrav.y)
    }
    
    func isDeviceTurningClockwise(turningDirection: Direction, stateDirection: Direction) -> Bool{
        var (current, old, diff): (Double,Double,Double)
        (current, old, diff) = whichGravAxes(pDirection: stateDirection)
        if(isGravityIncreasingInDirection(pDirection: turningDirection) && current < 0.0){
    //            print("Grav is INCREASING X")
                return true
        }
        else if(!isGravityIncreasingInDirection(pDirection: turningDirection) && current > 0.0){
    //            print("Grav is DECREASING along X")
                return true
            }
            else{
                return false
            }
        }

    
    func checkBombExplode(){
        if(self.gameManager.decreaseStability(percentage: 0.0)){
            self.navigateToEndScreen()
        }
    }
    func decreaseBombStabilityAndColor(pDmg: Double, pErr: String){
        print(pErr + "\n")
        self.gameManager.decreaseStability(percentage: pDmg)
//        self.unwrapViewController.updateBackgroundColor(pColor: self.gameManager.currentColor)
    }
    
    func increaseBombStabilityAndColor(){
        self.gameManager.increaseStability(percentage: self.dmgVal)
    }
    
    func isOverMaxAcceleration() -> Bool {
        // too much acceleration (shaking)
        var oldMotion = self.oldMotionData
        if(oldMotion.isMotionGreaterThanMaxInEveryDirection(pMotion: oldMotion.acceleration, maxX: self.maxAcc.x, maxY: self.maxAcc.y, maxZ: self.maxAcc.z)){
            return true
        }
        return false
    }
    
    func isOverMaxRotationRate() -> Bool {
        // too fast rotation (speed)
        var oldMotion = self.oldMotionData
        if(oldMotion.isMotionGreaterThanMaxInEveryDirection(pMotion: oldMotion.rotationRate, maxX: self.maxRotRate.x, maxY: self.maxRotRate.y, maxZ: self.maxRotRate.z)){
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
