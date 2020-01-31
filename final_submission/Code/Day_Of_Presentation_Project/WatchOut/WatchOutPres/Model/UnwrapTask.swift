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
//    var player: Player
//
//    var gravity: SIMD3<Double>?
//    var oldGravity: SIMD3<Double>?
//    var acceleration: SIMD3<Double>?
//    
//    override init(){
//        bomb = Bomb()
//        player = Player()
//        gravity = SIMD3<Double>()
//        acceleration = SIMD3<Double>()
//        super.init()
//    }
//
//    func PunishPlayer(pBomb: Bomb, pErrorMsg: String){
//        let PlayerError: String = "Damage Taken!"
//        print(PlayerError)
//        print(pErrorMsg)
//        pBomb.TakeDamage()
//    }
//    
//    func encouragePlayer(){
//        let encouragementMsg: String = "All is good"
//        print("All is good")
//    }
//    
//    func ExecuteMotion(pGrav: SIMD3<Double>?, pAcc: SIMD3<Double>?, pOldGrav: SIMD3<Double>?, pGoClockWise: Bool, pBomb: Bomb){
//        
//        // -- variable setup --------- --------- --------- --------- ---------
//        let perpendicularDirectionError = "Reason: Moving in (perpendicular)wrong direction"
//        let oppositeDirectionError = "Reason: Too Fast in wrong direction"
//        let tooFastWrongDirectionError = "Reason: Too Fast in correct direction"
//        let tooFastCorrectDirectionError = "Reason: Too Fast in wrong direction"
//        
//        //max change in magnitdue of gravity value and acceleration value
//        let max_grav_diff = 0.02
//        let acc_limit: Double = 5
//        
//        let diffZ = abs(pOldGrav!.z - pGrav!.z)
//        let diffY = abs(pOldGrav!.y - pGrav!.y)
//        let diffX = abs(pOldGrav!.x - pGrav!.x)
//        
//        // ------------ ------------ x-direction ------------ ------------
//        // - y to check direction gravity
//        // - x to check rate of change in gravity of x
//        // - z acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
//        
//        // ------------ ------------ z-direction ------------ ------------
//        // - x to check direction gravity
//        // - z to check rate of change in gravity of x
//        // - y acceleration should not move above a max limit(Should not move in this direction at all really but thats not the point
//        
//        
//        //check all possible errors(Will there be other errors here apart from player errors)
//        if( (pGrav!.y > 0.5 || pGrav!.y < -0.5) && pAcc!.y > acc_limit){
//            PunishPlayer(pBomb: pBomb, pErrorMsg:  perpendicularDirectionError)
//        }
//        else if(pAcc!.z > acc_limit || pAcc!.x > acc_limit){
//            PunishPlayer(pBomb: pBomb, pErrorMsg:  tooFastWrongDirectionError)
//        }
//        else{
//        
//        //phone face up (z-grav of phone is in -ve)
//        
////        if(pGrav!.z < 0){
//            //clock-wise(twisting away from the user) grav.x becomes positive
//            if (pGoClockWise == false){
//                PunishPlayer(pBomb: pBomb, pErrorMsg:  oppositeDirectionError)
//            }
//            else{
////                pGrav!.x < pOldGrav!.x &&
//                //is past max rotation speed
//                if (diffZ > max_grav_diff){
//                    PunishPlayer(pBomb: pBomb, pErrorMsg:  tooFastCorrectDirectionError)
//                }
//                //Is change within speed of rotation (max_dev) limits?
//                else if (diffZ < max_grav_diff){
//                    encouragePlayer()
//                }
//            }
//        }
//                
//            //anti clockwise(twisting towards the user) grav.x becomes positive
////            if ( pGoClockWise == true){
//////                pGrav!.x < pOldGrav!.x &&
////                //Is change within speed of rotation (max_dev) limits?
////                if (diffZ < max_grav_diff){
////                    print("All is good")
////                }
////                //is past max rotation speed
////                else if (diffZ > max_grav_diff){
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
//        // - z to check direction gravity
//        // - y to check rate of change in gravity of x
//        // - x should not move above a max limit(Should not move in this direction at all really but thats not the point
//            
//    }
//}
