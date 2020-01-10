//
//  ViewController.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 08.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import UIKit
import CoreMotion


func powerOfTwo(num: Double)-> Double{
    return pow(num, 2)
}
func roundFloat(p: Double) -> Double {
    let y = Double(round(1000*p)/1000)
    print(y)  // 1.236
    return y
}

func Addition3D(coOrds: Vector3D) -> Double{
    let h = roundFloat(p: sqrt(powerOfTwo(num: coOrds.x!) + powerOfTwo(num: coOrds.y!) + powerOfTwo(num: coOrds.z!)))
    return h
}




struct Vector3D {
    var x: Double? = 0.0
    var y: Double? = 0.0
    var z: Double? = 0.0
//    var vector: Double? = sqrt(powerOfTwo(x) + powerOfTwo(y) + powerOfTwo(z))
    var defaultStr: String = "pos"
//    var displayString: String = "x: \(x), y: \(y), z: \(z) \n "
}

//
//struct VectorAdded {
//    var coOrds: Vector3D
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




class ViewController: UIViewController {
    
//    self.view.backgroun
    let motion = CMMotionManager()

    var pos = Vector3D()
    var acc = Vector3D()
    var maxAcc = Vector3D()
    var grav = Vector3D()

    var vectorChosen: UnitVector? = .position
    var incrementalAcc = Vector3D()
    
    func unwrapGrav(pos: Vector3D, acc: Vector3D) -> UIColor{
//        self.grav
        var color = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
//        red = 1
        if self.grav.x! > 0{
            color =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        else if self.grav.x! <= 0{
            color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        }
        return color
    }
    
    func unwrapAcc() -> UIColor{
//        self.grav
        var color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        red = 1
        if self.maxAcc.x! > 5 {
            print("too fast")
//            if self.acc.x! > 5 {
//                color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//            }
        }
        else{
            if self.acc.x! > 0{
                color =  UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            }
            else if self.acc.x! <= 0{
                color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
            }
        }
        return color
    }
    
//    func changeColorfromIncrementalAcc(){
//        if self.incremental
//    }

    @IBOutlet var gyroView: UITextView!
    

    
    func VectorToColor(vector: Vector3D) -> UIColor {
        
        let pi = Double(CGFloat.pi)
            
        let redPercent = CGFloat((vector.x! + pi)/(2*pi))
        let greenPercent =  CGFloat((vector.y! + pi)/(2*pi))
        let bluePercent =  CGFloat((vector.z! + pi)/(2*pi))
            
        return UIColor(red: redPercent, green: greenPercent, blue: bluePercent, alpha: 1)
    }
    
    
    func setMotion3DVector(unit: UnitVector) -> Vector3D{
        var vector = Vector3D()
        switch unit{
        case .position:
            print("position")
            if let data = self.motion.deviceMotion {
                vector.x = roundFloat(p: data.attitude.pitch);
                vector.y = roundFloat(p: data.attitude.roll)
                vector.z = roundFloat(p: data.attitude.yaw)
            }
            self.pos = vector
        case .acceleration:
            print("acceleration")
            if let data = self.motion.deviceMotion {
               vector.x = roundFloat(p: data.userAcceleration.x)
               vector.y = roundFloat(p: data.userAcceleration.y)
               vector.z = roundFloat(p: data.userAcceleration.z)
           }
            self.acc = vector
        case .velocity:
            print("velocity")
        case .gravity:
            print("gravity")
            if let data = self.motion.deviceMotion {
                vector.x = roundFloat(p: data.gravity.x)
                vector.y = roundFloat(p: data.gravity.y)
                vector.z = roundFloat(p: data.gravity.z)
            }
            self.grav = vector

        }
        
        return vector
    }
    
    func updateMaxAcc(){
        if self.acc.x! > self.maxAcc.x!{
           self.maxAcc.x! = self.acc.x!
       }
       if self.acc.x! > self.maxAcc.y!{
           self.maxAcc.y! = self.acc.y!
       }
       if self.acc.x! > self.maxAcc.z!{
           self.maxAcc.z! = self.acc.z!
       }
    }

    func updateMinAcc(){
        if self.acc.x! > self.maxAcc.x!{
           self.maxAcc.x! = self.acc.x!
       }
       if self.acc.x! > self.maxAcc.y!{
           self.maxAcc.y! = self.acc.y!
       }
       if self.acc.x! > self.maxAcc.z!{
           self.maxAcc.z! = self.acc.z!
       }
    }
    
    func incrementAcceleration(vector: Double)-> UIColor{
        var lColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)

        var lAccX = abs(self.acc.x!)
        var lAccY = abs(self.acc.y!)
        var lAccZ = abs(self.acc.z!)
        
//        if vector > 5{
//            vector = roundFloat(p: vector + vector)
//
//        }
        
        if lAccX > 0.02{
            self.incrementalAcc.x = roundFloat(p: self.incrementalAcc.x! + lAccX)
        }
        if lAccY > 0.02{
            self.incrementalAcc.y = roundFloat(p: self.incrementalAcc.y! + lAccY)
        }
        if lAccZ > 0.02{
            self.incrementalAcc.z = roundFloat(p: self.incrementalAcc.z! + lAccZ)
        }
        
        if self.incrementalAcc.x! > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if self.incrementalAcc.y! > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if self.incrementalAcc.z! > 100{
            lColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return lColor
    }
    

    
    func startDeviceMotion() {
        
        self.pos.x = 5

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
                                           
                                    var posVector = Addition3D(coOrds: self.pos)
                                    var accVector = Addition3D(coOrds: self.acc)
                                    var gravVector = Addition3D(coOrds: self.grav)
                                    var incrementalAccVector = Addition3D(coOrds: self.incrementalAcc)
                                    
                                                                            
                                    self.updateMaxAcc()
  
//                                    let posString = "x: \(self.pos.x!), y: \(self.pos.y!), z: \(self.pos.z!) \n "
                                    let accString = "aX: \(self.acc.x!), \n aY: \( self.acc.y!),\n  aZ: \(self.acc.z!) \n"
                                    let maxAccString = "\n maxX: \(self.maxAcc.x!) \n maxY: \(self.maxAcc.y!) \n maxZ: \(self.maxAcc.z!) \n"
                                    let gravString = "\n gravX: \(self.grav.x!) \n gravY: \(self.grav.y!) \n gravZ: \(self.grav.z!) \n"
                                    
                                    let incremAccString = "increm_acc_X:\(self.incrementalAcc.x!)  \n increm_acc_Y: \(self.incrementalAcc.y!) \n increm_acc_Z: \(self.incrementalAcc.z!) \n"
                                    let incremAccVectorString = "increm_acc_Vector: \(incrementalAccVector) \n"
                                                                     
                                    
                                    self.gyroView.text = gravString  + accString + maxAccString + incremAccString + incremAccVectorString//posString  +
                                    
//                                    self.view.backgroundColor = self.VectorToColor(vector: self.pos)

//                                    self.view.backgroundColor = self.unwrapGrav(pos: self.pos, acc: self.acc)
                                    self.view.backgroundColor = self.incrementAcceleration()

                                    // Use the motion data in your app.
                                }
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

