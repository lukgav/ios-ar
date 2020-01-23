//
//  TwitchViewController.swift
//  WatchOut
//
//  Created by Guest User on 22/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class TwitchViewController: UIViewController {

    var controller: TwitchController?
    
    
    @IBOutlet weak var curPlayerName: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = TwitchController(twitchViewController: self)
        
        
        let curArrow: String? = controller?.myArrows.randomElement()
        switch curArrow {
        case "up-arrow":
            arrow.image = UIImage.init(named: "up-arrow")
            controller?.twitchUp(maxMovingSpeed: 0.5)
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.y -= 100
            }, completion: nil)
        case "down-arrow":
            arrow.image = UIImage.init(named: "down-arrow")
            controller?.twitchDown(maxMovingSpeed: 0.5)
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.y += 100
            }, completion: nil)
        case "left-arrow":
            arrow.image = UIImage.init(named: "left-arrow")
            controller?.twitchLeft(maxMovingSpeed: 0.5)
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.x -= 100
            }, completion: nil)
        default:
            arrow.image = UIImage.init(named: "right-arrow")
            controller?.twitchRight(maxMovingSpeed: 0.5)
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.x += 100
            }, completion: nil)
        }
        
    }
    
    func updateBackgroundColor(newColor: UIColor) {
        self.view.backgroundColor = newColor
    }
    
    @IBAction func NextTaskTouch(_ sender: Any) {
        controller?.navigateToNextTask()
    }
    
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    
    
    @IBAction func startMovingTheArrow(_ sender: Any) {
        let curArrow: String? = controller?.myArrows.randomElement()
        switch curArrow {
        case "down-arrow":
            arrow.image = UIImage.init(named: "down-arrow")
            UIView.animate(withDuration: 1, animations: {
                self.arrow.frame.origin.y += 50
            }, completion: nil)
        case "up-arrow":
            arrow.image = UIImage.init(named: "up-arrow")
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.y -= 100
            }, completion: nil)
        case "left-arrow":
            arrow.image = UIImage.init(named: "left-arrow")
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.x -= 100
            }, completion: nil)
        default:
            arrow.image = UIImage.init(named: "right-arrow")
            UIView.animate(withDuration: 2, animations: {
                self.arrow.frame.origin.x += 100
            }, completion: nil)
        }
    }
    
    
}
