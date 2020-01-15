//
//  DeliveryTask.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 15.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation
import UIKit

class DeliveryTask: MotionTask{

    var bomb: Bomb
    var player: Player

    var gravity: SIMD3<Double>?
    var oldGravity: SIMD3<Double>?
    var acc: SIMD3<Double>?
    var accCounter: SIMD3<Double>?

    override init(){
        bomb = Bomb()
        player = Player()
        gravity = SIMD3<Double>()
        acc = SIMD3<Double>()
        accCounter = SIMD3<Double>()
        super.init()
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
}
