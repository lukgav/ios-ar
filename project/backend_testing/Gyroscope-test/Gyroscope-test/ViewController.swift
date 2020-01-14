//
//  ViewController.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 08.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import UIKit
import CoreMotion

//    init(startingValue)
//    var vector: Double? = sqrt(powerOfTwo(x) + powerOfTwo(y) + powerOfTwo(z))
//    var defaultStr: String = "pos"
//    var displayString: String = "x: \(x), y: \(y), z: \(z) \n "
//}

//
//struct VectorAdded {
//    var coOrds: SIMD3<Double>
//    var vector: Double? = sqrt(powerOfTwo(coOrds.x) + powerOfTwo(coOrds.y) + powerOfTwo(coOrds.z))
//    var displayString: String = "x: \(coOrds.x), y: \(coOrds.y), z: \(coOrds.z) \n "
//
//}

enum UnitVector {
    case position
    case acceleration
    case velocity
    case gravity
}


func powerOfTwo(num: Double)-> Double{
    return pow(num, 2)
}
func roundFloat(p: Double) -> Double {
    let y = Double(round(1000*p)/1000)
    print(y)  // 1.236
    return y
}

func Addition3D(coOrds: SIMD3<Double>?) -> Double{
    let h = roundFloat(p: sqrt(powerOfTwo(num: coOrds!.x) + powerOfTwo(num: coOrds!.y) + powerOfTwo(num: coOrds!.z)))
    return h
}



func Unwrap(pGrav: SIMD3<Double>?, pAcc: SIMD3<Double>?, pOldGrav: SIMD3<Double>?){

    // -- variable setup --------- --------- --------- --------- ---------
    //max change in magnitdue of gravity value

    let max_diff = 0.05

    let diffZ = abs(pOldGrav!.z - pGrav!.z)
    let diffY = abs(pOldGrav!.y - pGrav!.y)
    let diffX = abs(pOldGrav!.x - pGrav!.x)
    
//
//    let z = pGrav!.z
//    let zOld = pOldGrav!.z
//    let dZ = abs(zOld - z)
//
//    let x = pGrav!.x
//    let xOld = pOldGrav!.z
//    let dX = abs(xOld - x)
//
//    let y = pGrav!.y
//    let yOld = pOldGrav!.y
//    let dY = abs(yOld - y)
    
    // ------------ ------------ x-direction ------------ ------------

    // ------------ ------------ z-direction ------------ ------------

    //phone face up (z-grav of phone is in -ve)
    if(pGrav!.z < 0){
        //clock-wise(twisting away from the user) grav.x becomes positive
        if (pGrav!.x > pOldGrav!.x){
            //Is change within speed of rotation (max_dev) limits?
            if (diffZ < max_diff){
                
            }
            //is past max rotation speed
            else if (diffZ > max_diff){
                
            }
        }
        //anti clockwise(twisting towards the user) grav.x becomes positive
        else if (pGrav!.x < pOldGrav!.x){
            //Is change within speed of rotation (max_dev) limits?
            if (diffZ < max_diff){
                
            }
            //is past max rotation speed
            else if (diffZ > max_diff){
                
            }
        }
    }
    // phone face down (z-grav of phone is in +ve)
    if(pGrav!.z > 0){
        //clock-wise(twisting away from the user) grav.x becomes positive
        if (pGrav!.x > pOldGrav!.x){
             //Is change within speed of rotation (max_dev) limits?
            if (diffZ < max_diff){
                
            }
            //is past max rotation speed
            else if (diffZ > max_diff){
                
            }
        }
        //anti clockwise(twisting towards the user) grav.x becomes positive
        else if (pGrav!.x < pOldGrav!.x){
            //Is change within speed of rotation (max_dev) limits?
            if (diffZ < max_diff){
                
            }
            //is past max rotation speed
            else if (diffZ > max_diff){
                
            }
        }
       //clock-wise

    }
    

    // ------------ ------------ y-direction ------------ ------------
}





class ViewController: UIViewController {
    
//    self.view.backgroun
    let motion = CMMotionManager()

    var vec_default : SIMD3<Double>? = nil
    
    var posVec: SIMD3<Double>? = nil
    
    var bomb: Bomb = Bomb()
    var wrapTask: WrapTask = WrapTask(self.bomb)
    
//    func taskA(){
//        self.posVec.x
//    }
    
    var pos : SIMD3<Double>? = SIMD3<Double>()
    var acc : SIMD3<Double>? = SIMD3<Double>()
    var maxAcc : SIMD3<Double>? = SIMD3<Double>()
    var grav : SIMD3<Double>? = SIMD3<Double>()
    var oldGrav : SIMD3<Double>? = SIMD3<Double>()
    
    var vectorChosen: UnitVector? = .position
    var accCounter : SIMD3<Double>? = SIMD3<Double>()

    
    func setUpMotion(){
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 0.1
            motion.magnetometerUpdateInterval = 0.1
            motion.gyroUpdateInterval = 0.1
//            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
//                print(data)
        }
    }
    
        
    func updateOldValues(){
        self.oldGrav = self.grav!
    }


    
    

    func unwrapGrav(pos: SIMD3<Double>, acc: SIMD3<Double>) -> UIColor{
//        self.grav!
        var color = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
//        red = 1
        if self.grav!.x > 0{
            color =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        else if self.grav!.x <= 0{
            color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        }
        return color
    }
    
    func unwrapAcc() -> UIColor{
//        self.grav!
        var color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        red = 1
        if self.maxAcc!.x > 5 {
            print("too fast")
//            if self.acc.x > 5 {
//                color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//            }
        }
        else{
            if self.acc!.x > 0{
                color =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            }
            else if self.acc!.x <= 0{
                color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
            }
        }
        return color
    }
    
//    func changeColorfromaccCounter(){
//        if self.incremental
//    }

    @IBOutlet var gyroView: UITextView!
    

    
    func VectorToColor(vector: SIMD3<Double>) -> UIColor {
        
        let pi = Double(CGFloat.pi)
            
        let redPercent = CGFloat((vector.x + pi)/(2*pi))
        let greenPercent =  CGFloat((vector.y + pi)/(2*pi))
        let bluePercent =  CGFloat((vector.z + pi)/(2*pi))
            
        return UIColor(red: redPercent, green: greenPercent, blue: bluePercent, alpha: 1)
    }
    
    
    func setMotion3DVector(unit: UnitVector) -> SIMD3<Double>{
        var vector : SIMD3<Double>? = SIMD3<Double>()
        switch unit{
        case .position:
            print("position")
            if let data = self.motion.deviceMotion {
                vector!.x = roundFloat(p: data.attitude.pitch);
                vector!.y = roundFloat(p: data.attitude.roll)
                vector!.z = roundFloat(p: data.attitude.yaw)
//                vector.x = roundFloat(p: data.)
                

            }
            self.pos = vector
        case .acceleration:
            print("acceleration")
            if let data = self.motion.deviceMotion {
//                vector = SIMD3<Double>(data.userAcceleration)
               vector!.x = roundFloat(p: data.userAcceleration.x)
               vector!.y = roundFloat(p: data.userAcceleration.y)
               vector!.z = roundFloat(p: data.userAcceleration.z)
           }
            self.acc = vector
        case .velocity:
            print("velocity")
        case .gravity:
            print("gravity")
            if let data = self.motion.deviceMotion {
                vector!.x = roundFloat(p: data.gravity.x)
                vector!.y = roundFloat(p: data.gravity.y)
                vector!.z = roundFloat(p: data.gravity.z)
            }
            self.grav = vector!

        }
        
        return vector!
    }
    
    func updateMaxAcc(){
        if self.acc!.x > self.maxAcc!.x{
           self.maxAcc!.x = self.acc!.x
       }
       if self.acc!.x > self.maxAcc!.y{
           self.maxAcc!.y = self.acc!.y
       }
       if self.acc!.x > self.maxAcc!.z{
           self.maxAcc!.z = self.acc!.z
       }
    }

    func updateMinAcc(){
         if self.acc!.x < self.maxAcc!.x{
            self.maxAcc!.x = self.acc!.x
        }
        if self.acc!.x < self.maxAcc!.y{
            self.maxAcc!.y = self.acc!.y
        }
        if self.acc!.x < self.maxAcc!.z{
            self.maxAcc!.z = self.acc!.z
        }
    }
    
    
    //accelertometer
    func CountAcceleration()-> UIColor{
        var lColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)

        var lAccX = abs(self.acc!.x)
        var lAccY = abs(self.acc!.y)
        var lAccZ = abs(self.acc!.z)
        
//        if vector > 5{
//            vector = roundFloat(p: vector + vector)
//
//        }
        
        if lAccX > 0.02{
            self.accCounter!.x = roundFloat(p: self.accCounter!.x + lAccX)
        }
        if lAccY > 0.02{
            self.accCounter!.y = roundFloat(p: self.accCounter!.y + lAccY)
        }
        if lAccZ > 0.02{
            self.accCounter!.z = roundFloat(p: self.accCounter!.z + lAccZ)
        }
        
        if self.accCounter!.x > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if self.accCounter!.y > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if self.accCounter!.z > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return lColor
    }
    

    
    func startDeviceMotion() {
        
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 30.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            let timer = Timer(fire: Date(), interval: (1.0 / 30.0), repeats: true,
                               block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    
//                                    pos.z
                                    // Get the attitude relative to the magnetic north reference frame.
//                                    self.vectorChosen = .position
//                                    self.setMotion3DVector(unit: self.vectorChosen!)
//
                                    self.vectorChosen = .acceleration
                                    self.setMotion3DVector(unit: self.vectorChosen!)
                                    self.vectorChosen = .gravity
                                    self.setMotion3DVector(unit: self.vectorChosen!)
                                           
                                    var posVector = self.pos!
                                    var accVector = self.acc!
                                    var gravVector = self.grav!
                                    var accCounterVector = self.accCounter!.round(FloatingPointRoundingRule.up)
                                    
                                    // Accelerometer code
                                    self.updateMaxAcc()
  
                                    
                                    //print to app
//                                    let posString = "x: \(self.pos.x), y: \(self.pos.y), z: \(self.pos.z) \n "
                                    let accString = "aX: \(self.acc!.x), \n aY: \( self.acc!.y),\n  aZ: \(self.acc!.z) \n"
                                    let maxAccString = "\n maxX: \(self.maxAcc!.x) \n maxY: \(self.maxAcc!.y) \n maxZ: \(self.maxAcc!.z) \n"
                                    let gravString = "\n gravX: \(self.grav!.x) \n gravY: \(self.grav!.y) \n gravZ: \(self.grav!.z) \n"
                                    
                                    let accCounterString = "increm_acc_X:\(self.accCounter!.x)  \n increm_acc_Y: \(self.accCounter!.y) \n increm_acc_Z: \(self.accCounter!.z) \n"
                                    let accCounterVectorString = "increm_acc_Vector: \(accCounterVector) \n"
                                                                     
                                    //keep this here
                                    self.gyroView.text = gravString  + accString + maxAccString + accCounterString + accCounterVectorString//posString  +
                                    

                                    self.view.backgroundColor = self.CountAcceleration()

                                    // Use the motion data in your app.
                                }
                                
                                Unwrap(pGrav: self.grav!, pAcc: self.acc!, pOldGrav: self.oldGrav!)
                                self.updateOldValues()
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
        
        // Do any additional setup after loading the view.
    }
}
