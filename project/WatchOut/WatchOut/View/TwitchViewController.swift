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
    
    @IBOutlet weak var arrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = TwitchController(twitchViewController: self)
        
        controller?.startTwitch()
    }
    
    func updateArrowImage(direction: TwitchDirection) {
        switch direction {
        case .Up:
            arrow.image = UIImage.init(named: "up-arrow")
            UIView.animate(withDuration: 1, animations: {
                self.arrow.frame.origin.y -= 70
            }, completion: nil)
        case .Down:
            arrow.image = UIImage.init(named: "down-arrow")
            UIView.animate(withDuration: 1, animations: {
                self.arrow.frame.origin.y += 70
            }, completion: nil)
        case .Left:
            arrow.image = UIImage.init(named: "left-arrow")
            UIView.animate(withDuration: 1, animations: {
                self.arrow.frame.origin.x -= 70
            }, completion: nil)
        case .Right:
            arrow.image = UIImage.init(named: "right-arrow")
            UIView.animate(withDuration: 1, animations: {
                self.arrow.frame.origin.x += 70
            }, completion: nil)
        }
    }
    
    func updateBackgroundColor(newColor: UIColor) {
        self.view.backgroundColor = newColor
    }

    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
}
