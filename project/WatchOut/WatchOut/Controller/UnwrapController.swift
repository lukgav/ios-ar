//
//  UnwrapController.swift
//  WatchOut
//
//  Created by Guest User on 14/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//
import Foundation

class UnwrapController {
    
    private let unwrapViewController : UnwrapViewController
    
    private let dmManager = DeviceMotionManager.shared
    private let observer = MotionDataObserver()
    private let gameManager = GameManager.shared
        
    private var oldMotionData: MotionData = MotionData()
    private var currentMotionData: MotionData = MotionData()
    private var diffMotionData: MotionData = MotionData()
    
    //---------------------Values currently set for Going in X direction---------------------
    private var minGrav: SIMD3<Double>?
    private var maxGrav: SIMD3<Double>?
    private var topMaxDiffGrav: SIMD3<Double>?
    private var bottomMaxDiffGrav: SIMD3<Double>?
    //---------------------Values currently set for Going in X direction---------------------

    ///----------------- These values are set at random in setup-----------------
    private var unwrapDirection: Direction = .x
    private var shouldTurnClockwise: Bool = true
    private var maxNumTurns: Int = 0
    private var turnCounter: Int = 0
    private var turnedOnce: Bool = false
    private var deviceTurnedAt: Double = 0.0
    private var deviceTurningStartPos: Double = 0.0
    ///-----------------These values are set at random in setup -----------------
    
    // Temporary variables
    private var xRandCount: Int = 0
    private var yRandCount: Int = 0
    private var zRandCount: Int = 0
    
    /// These are used for the timer BEFORE the player starts
    private var timer : Timer
    private var countDownTime: Double = 0
    private var timerInterval: Double = 1/10.0
    /// These are used for the timer BEFORE the player starts
    
    private var dmgVal: Double?
    private var isTaskComplete: Bool = false
    private var isGoingInCorrectDirection: Bool = false
    private var isUnwrapPastStart: Bool = false
    
    // TODO:
    //--------Backend-------
    // - Give player time to see read screen
    //      - a 5 second timer?
    //--------UI--------
    // What to show on screen:
    // - Num of turns to do!!!!!

    
    
    init(unwrapViewController: UnwrapViewController, pDifficulty: Difficulty) {
        self.unwrapViewController = unwrapViewController
        self.timer = Timer()
        self.setMotionDifficulty(pDifficulty: pDifficulty)
        self.setUpUnwrap()
        self.loadUI(pDirection: unwrapDirection)
        self.isUnwrapPastStart = false
//        self.getRandomTurns()
    }
    // MARK: - Unwrap Logic

    func loadUI(pDirection: Direction){
        let nextPlayer =  gameManager.getNextRandomPlayer()
        
        unwrapViewController.updateBackgroundColor(pColor: gameManager.currentColor)
        // TODO: randomize direction AND clockWise Boolean
        unwrapViewController.updateTurningImage(direction: pDirection, goClockwise: self.shouldTurnClockwise)
    }

    func setMotionDifficulty(pDifficulty: Difficulty){
        switch pDifficulty{
            case .Easy:
                self.setRangeOfMotion(lMax: 0.6, lMin: -0.6, lTopMax: 0.7, lBottMax: 0.45, pDmg: 0.01)
            case .Medium:
                self.setRangeOfMotion(lMax: 0.4, lMin: -0.4, lTopMax: 0.5, lBottMax: 0.3 , pDmg: 0.02)
            case .Hard:
                self.setRangeOfMotion(lMax: 0.2, lMin: -0.2, lTopMax: 0.4, lBottMax: 0.15, pDmg: 0.03)
        }
    }
    
    func setRangeOfMotion(lMax: Double, lMin: Double, lTopMax: Double, lBottMax: Double, pDmg: Double){
        dmgVal = pDmg
        minGrav = SIMD3<Double>(x: lMin, y: lMin, z: lMin)
        maxGrav = SIMD3<Double>(x: lMax, y: lMax, z: lMax)
        topMaxDiffGrav = SIMD3<Double>(x: lTopMax, y: lTopMax, z: lTopMax)
        bottomMaxDiffGrav =  SIMD3<Double>(x: lBottMax, y: lBottMax, z: lBottMax)
    }
    
    func setUpUnwrap(isRand: Bool = true){
        maxNumTurns = 4
        if isRand{
//            getRandomTurns()
            getRandomClockwiseTurn()
            getRandomDirection()
        }
        else{
            unwrapDirection = .z
            shouldTurnClockwise = true
        }
    }
    
    func getRandomTurns(){
        self.maxNumTurns = Int.random(in: 1...2)
    }
    func getRandomClockwiseTurn(){
        self.shouldTurnClockwise = Bool.random()
//            Int.random(in: 0...3)
    }
    
    func getRandomDirection(){
        let dir = Direction.allCases.randomElement()!
//        dir = val
        self.iterateCounter(pDirection: dir)
        print("Random Direction: \(dir)")
//        print("xCount:\(xRandCount) yCount:\(yRandCount) zCount: \(zRandCount)")
        self.unwrapDirection =  dir
    }
    
    func iterateCounter(pDirection: Direction){
        switch pDirection{
        case .x:
            xRandCount += 1
        case .y:
            yRandCount += 1
        case .z:
            zRandCount += 1
        }
    }
    
    func roundtoThousandth(pNum: Double)->Double{
        return round(100*pNum) / 100
    }
    
    func isWithinRange(val: Double,min: Double,max: Double) ->Bool{
        return (val < max) && (val > min)
    }
    
    /// Starting position is when the phone is facing towards the user (x=0,y=-1,z=0)
    func startUnwrap(pCountDownDuration: Double){

//        self.startCountdown(duration: pCountDownDuration)
//        self.stopCountdown()
        self.setTurningStartPos(pDirection: self.unwrapDirection)
        dmManager.currentMotionData.addObserver(observer) { newMotionData in
            self.printData(pDirection: self.unwrapDirection)
            self.loadNewData(pNewMotionData: newMotionData)
            self.checkEndUnwrapCondition()
            self.devicePastStart(pDirection: self.unwrapDirection)
            /// Players mistakes and consequences are checked below
            self.UnwrapInDirection(pDirection: self.unwrapDirection)
            ///Update oldMotionData and background color. Do here AFTER all computation is done
            self.oldMotionData = self.currentMotionData
            self.unwrapViewController.updateBackgroundColor(pColor: self.gameManager.currentColor)
        }
        return
    }
    
    // MARK: - BELOW: Load, update Unwrap values, UI and print data etc...
    
    func loadNewData(pNewMotionData: MotionData){
        self.currentMotionData = pNewMotionData
        self.numOfTurnsMoved(pDirection: self.unwrapDirection)
        self.diffMotionData = self.currentMotionData.diff(other: self.oldMotionData)
    }
    
    func printData(pDirection: Direction){
        print("UnwrapDir: \(unwrapDirection)")
        printDataToDevice()
//        printMotionData(pDirection: pDirection)

    }
    
    func printMotionData(pDirection: Direction){
//        printAttData(pDirection: pDirection)
//        printAccData(pDirection: pDirection)
//        printRotData(pDirection: pDirection)
        printGravData(pDirection: pDirection)
    }
    func printDataToDevice(){
        var command: String = "Input Command"
        if(isGoingInCorrectDirection){
            command = "CORRECT Direction"
        }
        else if(!isGoingInCorrectDirection){
            command = "FALSE Direction"
        }
        
        unwrapViewController.updateDirectionText(pDirectionStr: command)
        unwrapViewController.updateNumOfTurns(pTurns: maxNumTurns - turnCounter)
    }
    
    func printRotData(pDirection: Direction){
        switch pDirection{
        case .x:
            print("---------------------------------------------------")
            print("oldRotX: \(self.oldMotionData.rotationRate.x)")
            print("curRotX: \(self.currentMotionData.rotationRate.x)")
            print("diffRotX: \(self.diffMotionData.rotationRate.x)")
            print("-------------")
            print("curRotZ: \(self.currentMotionData.rotationRate.z)")
            print("curRotY: \(self.currentMotionData.rotationRate.y)")
        case .y:
            print("---------------------------------------------------")
            print("oldRotY: \(self.oldMotionData.rotationRate.y)")
            print("curRotY: \(self.currentMotionData.rotationRate.y)")
            print("diffRotY: \(self.diffMotionData.rotationRate.y)")
            print("-------------")
            print("curRotZ: \(self.currentMotionData.rotationRate.z)")
            print("curRotX: \(self.currentMotionData.rotationRate.x)")
        case .z:
            print("---------------------------------------------------")
            print("oldRotX: \(self.oldMotionData.rotationRate.x)")
            print("curRotX: \(self.currentMotionData.rotationRate.x)")
            print("diffRotZX: \(self.diffMotionData.rotationRate.x)")
            print("-------------")
            print("curRotY: \(self.currentMotionData.rotationRate.y)")
            print("curRotZ: \(self.currentMotionData.rotationRate.z)")
        }
    }
    
    func printAccData(pDirection: Direction){
        switch pDirection{
        case .x:
            print("---------------------------------------------------")
            print("oldAccX: \(self.oldMotionData.acceleration.x)")
            print("currAccX: \(self.currentMotionData.acceleration.x)")
            print("diffAccX: \(self.diffMotionData.acceleration.x)")
            print("-------------")
            print("currAccZ: \(self.currentMotionData.acceleration.z)")
            print("currAccY: \(self.currentMotionData.acceleration.y)")
        case .y:
            print("---------------------------------------------------")
            print("oldAccY: \(self.oldMotionData.acceleration.y)")
            print("currAccY: \(self.currentMotionData.acceleration.y)")
            print("diffAccY: \(self.diffMotionData.acceleration.y)")
            print("-------------")
            print("currAccZ: \(self.currentMotionData.acceleration.z)")
            print("currAccX: \(self.currentMotionData.acceleration.x)")
        case .z:
            print("---------------------------------------------------")
            print("oldAccX: \(self.oldMotionData.acceleration.x)")
            print("currAccX: \(self.currentMotionData.acceleration.x)")
            print("diffAccZX: \(self.diffMotionData.acceleration.x)")
            print("-------------")
            print("currAccY: \(self.currentMotionData.acceleration.y)")
            print("currAccZ: \(self.currentMotionData.acceleration.z)")
        }
    }
    
    func printAttData(pDirection: Direction){
        if(isTaskComplete){
            print("Good job! Task is finished! ")
        }
        switch pDirection{
        case .x:
            print("---------------------------------------------------")
            print("oldAttX: \(self.oldMotionData.attitude.x)")
            print("currentAttX: \(self.currentMotionData.attitude.x)")
            print("DiffAttX: \(self.diffMotionData.attitude.x)")
            print("-------------")
            print("currentAttZ: \(self.currentMotionData.attitude.z)")
            print("currentAttY: \(self.currentMotionData.attitude.y)")
        case .y:
            print("---------------------------------------------------")
            print("oldAttY: \(self.oldMotionData.attitude.y)")
            print("currentAttY: \(self.currentMotionData.attitude.y)")
            print("DiffAttY: \(self.diffMotionData.attitude.y)")
            print("-------------")
            print("currentAttZ: \(self.currentMotionData.attitude.z)")
            print("currentAttX: \(self.currentMotionData.attitude.x)")
        case .z:
            print("---------------------------------------------------")
            print("oldAttX: \(self.oldMotionData.attitude.x)")
            print("currentAttX: \(self.currentMotionData.attitude.x)")
            print("DiffAttX: \(self.diffMotionData.attitude.x)")
            print("-------------")
            print("currentAttY: \(self.currentMotionData.attitude.y)")
            print("currentAttZ: \(self.currentMotionData.attitude.z)")
        }
    }
    
    func printGravData(pDirection: Direction){
        if(isTaskComplete){
            print("Good job! Task is finished! ")
        }
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
            print("oldGravX: \(self.oldMotionData.gravity.x)")
            print("currentGravX: \(self.currentMotionData.gravity.x)")
            print("DiffGravX: \(self.diffMotionData.gravity.x)")
            print("-------------")
            print("currentGravY: \(self.currentMotionData.gravity.y)")
            print("currentGravZ: \(self.currentMotionData.gravity.z)")
        }
    }
    
    // MARK: - ABOVE: Load, update Unwrap values, UI and print data etc...
    
    // MARK: - BELOW: Check Unwrap Direction
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
//            maxNumTurns = 2
            self.checkUnwrapInDirection(pTurningDir: .x, pStateDir: .z, pWobbleDir: .y)
        case .y:
//            maxNumTurns = 2
            //Need to check these values to make sure if this the correct orientation
            self.checkUnwrapInDirection(pTurningDir: .y, pStateDir: .z, pWobbleDir: .x)
        case .z:
//            maxNumTurns = 2
            //Need to check these values to make sure if this the correct orientation
            self.checkUnwrapInDirection(pTurningDir: .y, pStateDir: .x, pWobbleDir: .z)
        }
    }
    
    func checkUnwrapInDirection(pTurningDir: Direction, pStateDir: Direction, pWobbleDir: Direction){
        self.isGoingInCorrectDirection = self.isDeviceTurningInCorrectDirection(pTurningDirection: pTurningDir, pStateDirection: pStateDir)
        if(self.isGoingInCorrectDirection){
                //check if gravity is out of range in y-direction
        //                print("Going in right direction")
//            self.isGoingInCorrectDirection = true
            self.checkGravPosition(pDirection: pWobbleDir)
            self.checkChangeinGrav()
        }
        else{
//            self.isGoingInCorrectDirection = false
            self.decreaseBombStabilityAndColor(pDmg: self.dmgVal!, pErr: "Going in wrong direction")
        }
    }
    
    func setTurningStartPos(pDirection: Direction){
        switch pDirection{
        case .x:
            deviceTurningStartPos = self.currentMotionData.gravity.x
        case .y:
            deviceTurningStartPos = self.currentMotionData.gravity.y
        case .z:
            deviceTurningStartPos = self.currentMotionData.gravity.y
        }
    }
    


    func numOfTurnsMoved(pDirection: Direction){
        var lMin: Double = 0.05
        var lMax: Double = 0.20
        switch pDirection{
        case .x:

            checkNumOfTurns(turningGravDirectionVal: self.currentMotionData.gravity.x, stateGravDirectionVal: self.currentMotionData.gravity.z, pMin: lMin,pMax: lMax)
        case .y:

            checkNumOfTurns(turningGravDirectionVal: self.currentMotionData.gravity.y, stateGravDirectionVal: self.currentMotionData.gravity.z, pMin: lMin,pMax: lMax)
        case .z:

            checkNumOfTurns(turningGravDirectionVal: self.currentMotionData.gravity.x, stateGravDirectionVal: self.currentMotionData.gravity.y, pMin: lMin,pMax: lMax)
        }
        print("turnCounter: \(turnCounter)")
    }
    
    //Need to set this for x and z diretcion
    // must have a different min and max direction
    func devicePastStart(pDirection: Direction){
        if(!self.isUnwrapPastStart){
            var lDiff: Double?
            let lMaxVal: Double = 0.7
            switch pDirection{
            case .x:
                isDevicePastStartInMotion(pMotion: self.currentMotionData.gravity.x)
            case .y:
                isDevicePastStartInMotion(pMotion: self.currentMotionData.gravity.y)
            case .z:
                isDevicePastStartInMotion(pMotion: self.currentMotionData.gravity.y)
            }
        }
    }
        
    func isDevicePastStartInMotion(pMotion: Double){
        var lDiff: Double?
        let lMaxVal: Double = 0.7
        lDiff = abs(deviceTurningStartPos - pMotion)
        print("START diff Value: \(lDiff!)")
        if(lDiff! > lMaxVal){
            print("-----------PassedMaxValue------------")
            self.isUnwrapPastStart = true
            return
        }
    }
    
    func checkNumOfTurns(turningGravDirectionVal: Double, stateGravDirectionVal: Double, pMin: Double, pMax: Double){
//        isWithinRange(val: deviceTurningStartPos, min: pMin, max: pMax)  ||
        if(self.isUnwrapPastStart){
            if(self.isGoingInCorrectDirection){
                let mustBePassed = 0.4
                var diffMotion: Double
                diffMotion = abs(self.deviceTurnedAt - turningGravDirectionVal)
                print("DiffMotion: \(diffMotion)")
                if (!self.turnedOnce &&
                    self.isDeviceFaceUp(stateGravDirectionVal: stateGravDirectionVal) &&
                    isGoingInCorrectDirection){
                    if(isWithinRange(val: turningGravDirectionVal, min: pMin, max: pMax)){
                        self.turnedOnce = true
                        self.deviceTurnedAt = turningGravDirectionVal
                        turnCounter += 1
                    }
                }
                else if(diffMotion > mustBePassed){
                    print("Value is passed")
                    self.deviceTurnedAt = 0
                    self.turnedOnce = false
                }
            }
        }
    }
    
    func isDeviceFaceUp(stateGravDirectionVal: Double) -> Bool{
        return stateGravDirectionVal < 0.0
    }
    
    func isDeviceTurningInCorrectDirection(pTurningDirection: Direction, pStateDirection: Direction) -> Bool {
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
        return false
    }

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
    
// MARK: - check Clockwise or Anti-Clockwise direction and if that matches teh directionthe playe should go in
    func isDeviceTurningClockwise(turningDirection: Direction, stateDirection: Direction) -> Bool{
        var (current, old, diff): (Double,Double,Double)
        (current, old, diff) = whichGravAxes(pDirection: stateDirection)
        var isFaceUp = self.isDeviceFaceUp(stateGravDirectionVal: current)
        if(isGravityIncreasingInDirection(pDirection: turningDirection) && isFaceUp){
    //            print("Grav is INCREASING X")
                return true
        }
        else if(!isGravityIncreasingInDirection(pDirection: turningDirection) && !isFaceUp){
    //            print("Grav is DECREASING along X")
                return true
            }
            return false
        }
    
    // MARK: - Check if Turning is going to fast
    /// Check if change in Gravity in one or more directions is too much
    func checkChangeinGrav(){
        //X Direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.x, minVal: self.bottomMaxDiffGrav!.x, maxVal: self.topMaxDiffGrav!.x)
        //Z direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.z, minVal: self.bottomMaxDiffGrav!.z, maxVal: self.topMaxDiffGrav!.z)
        //Y Direction
        checkChangeinGravinDirection(val: self.diffMotionData.gravity.y, minVal: self.bottomMaxDiffGrav!.y, maxVal: self.topMaxDiffGrav!.y)
    }
    
    func checkChangeinGravinDirection(val: Double, minVal: Double, maxVal: Double){
        if(val > maxVal){
            decreaseBombStabilityAndColor(pDmg: self.dmgVal!, pErr: "Over max change in gravity ")
        }
        else if(isWithinRange(val: val, min: minVal ,max: maxVal)){
            var lDmg: Double
            lDmg = (self.dmgVal!/10) * val
            decreaseBombStabilityAndColor(pDmg: lDmg, pErr: "Too much Change in gravity ")
        }
    }

    // MARK: - Check if Player is wobbling too much
    func checkGravPosition(pDirection: Direction)-> Bool{
        let curMotion = self.currentMotionData
        if(curMotion.isOutOfRangeInDirection(pMotion: curMotion.gravity, pDirection: pDirection, maxValue: self.maxGrav!.y, minValue: self.minGrav!.y)){
            decreaseBombStabilityAndColor(pDmg: self.dmgVal!, pErr: "gravity:  Out of Range in \(pDirection.toString)")
            return true
        }
        return false
    }
    
    func isOutofGravYRange() -> Bool{
        return !isWithinRange(val: self.oldMotionData.gravity.y, min: self.minGrav!.y, max: self.maxGrav!.y)
    }
    
    // MARK:   - Check Finish Condition
    
    func checkEndUnwrapCondition(){
        self.checkBombExplode()
        self.checkifTaskisCompleted()
    }
    
    func checkBombExplode(){
        if(self.gameManager.shouldExplode()){
            self.navigateToEndScreen()
        }
    }
    
    func checkifTaskisCompleted(){
        // + 1
        if (turnCounter >= maxNumTurns){
            self.isTaskComplete = true
            // ----------------- Andi: Should This be TRUE??? -----------------
            self.endUnwrap(stopDeviceMotion: false)
            self.navigateToNextTask()
        }
    }
    
    func endUnwrap(stopDeviceMotion: Bool) -> Bool {
        print("END UNWRAP")
        dmManager.currentMotionData.removeObserver(observer)
        if (stopDeviceMotion) {
            return dmManager.stopDeviceMotion()
        }
        return true
    }
    
    
    // MARK: - Interact with Bomb and GameManager
    
    func decreaseBombStabilityAndColor(pDmg: Double, pErr: String){
        print(pErr + "\n")
        self.gameManager.decreaseStability(percentage: pDmg)
//        self.unwrapViewController.updateBackgroundColor(pColor: self.gameManager.currentColor)
    }
    
    func increaseBombStabilityAndColor(){
        self.gameManager.increaseStability(percentage: self.dmgVal!)
    }
    
    // MARK: - Countdown Logic
    
    func startCountdown(duration: Double) {
        
        print("Timer started")
        
        self.countDownTime = duration
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: true) { timer in
            self.countDownTime -= self.timerInterval
            
            if (self.countDownTime <= 0.0) {
                return
//                self.startUnwrap()
            }
            else {
//                if (self.countDownTime < duration - self.timerInterval*5) {
//                    print("Allow user to read data")
//                }
                print("CountDownTime: \(self.countDownTime)")
                self.unwrapViewController.updateTimer(newTime: self.countDownTime)
            }
            
        }
        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        return
    }
    
    func stopCountdown() {
        timer.invalidate()
        print("Timer stopped")
    }
    
    // MARK: - Navigation

    func navigateToNextTask() {
        if (self.endUnwrap(stopDeviceMotion: false)) {
            unwrapViewController.performSegue(withIdentifier: Constants.TwitchSegue, sender: self)
        }
    }

    func navigateToHome() {
        gameManager.quitCurrentGame()
        if (self.endUnwrap(stopDeviceMotion: true)) {
            unwrapViewController.performSegue(withIdentifier: Constants.HomeSegue, sender: self)
        }
    }

    func navigateToEndScreen() {
        if (self.endUnwrap(stopDeviceMotion: true)) {
            unwrapViewController.performSegue(withIdentifier: Constants.BombExplodedSegue, sender: self)
        }
    }
}
