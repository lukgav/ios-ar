//
//  UnwrapViewController.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class UnwrapViewController: UIViewController {

    var controller: UnwrapController?

//    @IBOutlet weak var currentPlayer: UILabel!
    @IBOutlet weak var countDownTimeLabel: UILabel!
    @IBOutlet var directionWrap: UIImageView!
    
    @IBOutlet weak var numOfTurns: UITextView!
    @IBOutlet weak var checkDirection: UITextView!
    //    @IBOutlet weak var directionToGo: UITextView!
//    @IBOutlet weak var numOfTurns: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        controller = UnwrapController(unwrapViewController: self, pDifficulty: .Easy)
        controller?.startUnwrap(pCountDownDuration: 4.0)
        //curPlayer.text = String(currentP)
    }
    
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    @IBAction func NextTaskTouch(_ sender: Any) {
        controller?.navigateToNextTask()
    }
    
    func updateDirectionText(pDirectionStr: String){
        self.checkDirection.text = pDirectionStr
    }
    
    func updateBackgroundColor(pColor: UIColor) {
        self.checkDirection.backgroundColor = pColor
        self.numOfTurns.backgroundColor = pColor
        self.view.backgroundColor = pColor
    }
    
    func updateNumOfTurns(pTurns: Int){
        self.numOfTurns.text = "Turns Left: \(pTurns)"
    }
    
    func updateTimerLabel(newTime: Double) {
        // shows one decimal
        countDownTimeLabel.text = String(Double(round(10*newTime)/10))
    }
    
    func loadImage(pImageName: String){
        directionWrap.image = UIImage.init(named: pImageName)
//        UIView.animate(withDuration: 2, animations:
//            {
//                self.directionWrap.frame.origin.y -= 200
//            },
//                       completion: nil)
    }

    func updateTimer(newTime: Double) {
        // shows one decimal
        countDownTimeLabel.text = String(Double(round(10*newTime)/10))
    }
    
    func updateTurningImage(direction: Direction, goClockwise: Bool) {
        switch direction {
        case Direction.x:
            if(goClockwise){
                loadImage(pImageName: "rotationXMir")
            }
            else{
                loadImage(pImageName: "rotationX")
            }
        case Direction.y:
           if(goClockwise){
                loadImage(pImageName: "rotationYMir")
            }
            else{
                loadImage(pImageName: "rotationY")
            }
        case Direction.z:
            if(goClockwise){
                loadImage(pImageName: "rotationZ")
            }
            else{
                loadImage(pImageName: "rotationZMir")
            }
        }
    }
}

