//
//  UnwrapTask.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 14.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation


class WrapTask: MotionTask{

    var bomb: Bomb
    var gravity: SIMD3<Double>?
    var oldGravity: SIMD3<Double>?
    var acceleration: SIMD3<Double>?
   
    init(pBomb: Bomb){
        bomb = Bomb()
        gravity = SIMD3<Double>()
        acceleration = SIMD3<Double>()
        super.init()
    }

    func ExecuteMotion(pGrav: SIMD3<Double>?, pAcc: SIMD3<Double>?, pOldGrav: SIMD3<Double>?, pGoClockWise: Bool){
        
        // -- variable setup --------- --------- --------- --------- ---------
        //max change in magnitdue of gravity value
        
        let max_diff = 0.05
        
        let diffZ = abs(pOldGrav!.z - pGrav!.z)
        let diffY = abs(pOldGrav!.y - pGrav!.y)
        let diffX = abs(pOldGrav!.x - pGrav!.x)
        
        
        // ------------ ------------ x-direction ------------ ------------

        // ------------ ------------ z-direction ------------ ------------

        //phone face up (z-grav of phone is in -ve)
//        if(pGrav!.z < 0){
            //clock-wise(twisting away from the user) grav.x becomes positive
            if (pGrav!.x > pOldGrav!.x && pGoClockWise == true){
                //Is change within speed of rotation (max_dev) limits?
                if (diffZ < max_diff){
                    print("All is good")
                }
                //is past max rotation speed
                else if (diffZ > max_diff){
                    bomb.TakeDamage()
                }
            }
            else{
                bomb.TakeDamage()
            }
                
            //anti clockwise(twisting towards the user) grav.x becomes positive
            if (pGrav!.x < pOldGrav!.x && pGoClockWise == true){
                //Is change within speed of rotation (max_dev) limits?
                if (diffZ < max_diff){
                    print("All is good")
                }
                //is past max rotation speed
                else if (diffZ > max_diff){
                    bomb.TakeDamage()
                }
            }
            else{
                bomb.TakeDamage()
            }
            
//        }
        // phone face down (z-grav of phone is in +ve)
//        if(pGrav!.z > 0){
//            //clock-wise(twisting away from the user) grav.x becomes positive
//            if (pGrav!.x > pOldGrav!.x){
//                 //Is change within speed of rotation (max_dev) limits?
//                if (diffZ < max_diff){
//                    print("All is good")
//
//                }
//                //is past max rotation speed
//                else if (diffZ > max_diff){
//                    bomb.TakeDamage()
//                }
//            }
//            //anti clockwise(twisting towards the user) grav.x becomes positive
//            else if (pGrav!.x < pOldGrav!.x){
//                //Is change within speed of rotation (max_dev) limits?
//                if (diffZ < max_diff){
//                    print("All is good")
//
//                }
//                //is past max rotation speed
//                else if (diffZ > max_diff){
//                    bomb.TakeDamage()
//                }
//            }
//           //clock-wise
//
//        }
        

        // ------------ ------------ y-direction ------------ ------------
    }
}
