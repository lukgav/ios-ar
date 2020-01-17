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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        controller = UnwrapController(unwrapViewController: self)
        
        controller?.startUnwrapAroundZ()
        
        curPlayer.text = String(currentP)
    }
    func updateBackgroundColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    @IBAction func QuitGameTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
    
    @IBAction func NextTaskTouch(_ sender: Any) {
        controller?.navigateToNextTask()
    }
    
    
    @IBOutlet weak var curPlayer: UILabel!
    
}
