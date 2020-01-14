//
//  GameManager.swift
//  Gyroscope-test
//
//  Created by Luke Gavin on 14.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

import Foundation

class GameManager{
    var player: Player
    var bomb: Bomb
    var task: MotionTask
    
    init(){
        bomb = Bomb()
        player = Player()
        task = MotionTask()
    }
    
    func runTask() -> Boolean{
        var result = task.ExecuteMotion()
        return result
    }
    
    func UpdateBomb(){
        Update
    }
    
    func UpdatePlayer(){
        
    }
    
}
