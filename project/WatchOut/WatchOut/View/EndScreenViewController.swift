//
//  EndScreenViewController.swift
//  WatchOut
//
//  Created by iOS1920 on 20.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
//import SwiftGifOrigin

class EndScreenViewController: UIViewController {

    @IBOutlet weak var loserName: UILabel!
    @IBOutlet weak var explodeGif: UIImageView!
    
    var controller : EndScreenController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = EndScreenController(endScreenViewController: self)
        
        //loserName.text = self.gameManager.loserPlayer!.name
        
        //explodeGif.image = UIImage.gif(name: "explode")
    }
        
    @IBAction func BackToHomeTouch(_ sender: Any) {
        controller?.navigateToHome()
    }
}
