////
////  UnwrapTask.swift
////  Gyroscope-test
////
////  Created by Luke Gavin on 14.01.20.
////  Copyright © 2020 Luke Gavin. All rights reserved.
////
//
//import Foundation
//
//
//class WrapTask: MotionTask{
//
//    var bomb: Bomb
//    var gravity: SIMD3<Double>?
//    var oldGravity: SIMD3<Double>?
//    var acceleration: SIMD3<Double>?
//    
//    override init(){
//        bomb = Bomb()
//        gravity = SIMD3<Double>()
//        acceleration = SIMD3<Double>()
//        super.init()
//    }
//
//    func ExecuteMotion(pGrav: SIMD3<Double>?, pAcc: SIMD3<Double>?, pOldGrav: SIMD3<Double>?, pGoClockWise: Bool, pBomb: Bomb){
//        
//        // -- variable setup --------- --------- --------- --------- ---------
//        //max change in magnitdue of gravity value
//        
//        let max_diff = 0.02
//        
//        let diffZ = abs(pOldGrav!.z - pGrav!.z)
//        let diffY = abs(pOldGrav!.y - pGrav!.y)
//        let diffX = abs(pOldGrav!.x - pGrav!.x)
//        
//        
//        // ------------ ------------ x-direction ------------ ------------
//        // - y to check direction gravity
//        // - x to check rate of change in gravity of x
//        // - z should not move above a max limit(Should not move in this direction at all really but thats not the point
//        
//        // ------------ ------------ z-direction (use x to check direction, z to check rate of change, and y should not move above a max limit------------ ------------
//
//        //phone face up (z-grav of phone is in -ve)
//        
//        
////        if(pGrav!.z < 0){
//            //clock-wise(twisting away from the user) grav.x becomes positive
//        
//            
//            if (pGoClockWise == false){
//                print("Damage Taken!!!!")
//            }
//            else{
//                pBomb.TakeDamage()
////                pGrav!.x < pOldGrav!.x &&
//                //Is change within speed of rotation (max_dev) limits?
//                if (diffZ < max_diff){
//                    print("Damage Taken!!!!")
//                    pBomb.TakeDamage()
//                }
//                //is past max rotation speed
//                else if (diffZ > max_diff){
//                    print("All is good")
//                }
//            }
//                
//            //anti clockwise(twisting towards the user) grav.x becomes positive
////            if ( pGoClockWise == true){
//////                pGrav!.x < pOldGrav!.x &&
////                //Is change within speed of rotation (max_dev) limits?
////                if (diffZ < max_diff){
////                    print("All is good")
////                }
////                //is past max rotation speed
////                else if (diffZ > max_diff){
////                    print("Damage Taken!!!!")
////
////                    pBomb.TakeDamage()
////                }
////            }
////            else{
////                print("Damage Taken!!!!")
////
////                pBomb.TakeDamage()
////            }
//            
////        }
//        // phone face down (z-grav of phone is in +ve)
////        if(pGrav!.z > 0){
////            //clock-wise(twisting away from the user) grav.x becomes positive
////            if (pGrav!.x > pOldGrav!.x){
////                 //Is change within speed of rotation (max_dev) limits?
////                if (diffZ < max_diff){
////                    print("All is good")
////
////                }
////                //is past max rotation speed
////                else if (diffZ > max_diff){
////                    bomb.TakeDamage()
////                }
////            }
////            //anti clockwise(twisting towards the user) grav.x becomes positive
////            else if (pGrav!.x < pOldGrav!.x){
////                //Is change within speed of rotation (max_dev) limits?
////                if (diffZ < max_diff){
////                    print("All is good")
////
////                }
////                //is past max rotation speed
////                else if (diffZ > max_diff){
////                    bomb.TakeDamage()
////                }
////            }
////           //clock-wise
////
////        }
//        
//
//        // ------------ ------------ y-direction ------------ ------------
//    }
//}
