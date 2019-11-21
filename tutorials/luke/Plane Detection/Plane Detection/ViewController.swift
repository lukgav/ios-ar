//
//  ViewController.swift
//  Plane Detection
//
//  Created by Luke Gavin on 21.11.19.
//  Copyright © 2019 Luke Gavin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit



class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions =
            [
                ARSCNDebugOptions.showWorldOrigin,
                ARSCNDebugOptions.showFeaturePoints
            ]
        sceneView.delegate = self as? ARSCNViewDelegate
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
}
