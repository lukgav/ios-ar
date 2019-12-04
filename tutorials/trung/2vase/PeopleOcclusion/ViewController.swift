/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var arView: ARView!
    @IBOutlet var messageLabel: RoundedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let vase1 = try ModelEntity.load(named: "vase")
            let vase2 = try ModelEntity.load(named: "vase2")
            
            // Place model on a horizontal plane.
            let anchor1 = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
            let anchor2 = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
            
            arView.scene.anchors.append(anchor1)
            arView.scene.anchors.append(anchor2)
            
            vase1.scale = [1, 1, 1] * 0.006
            vase2.scale = [1, 1, 1] * 0.010
            
            anchor1.children.append(vase1)
            anchor2.children.append(vase2)
        } catch {
            fatalError("Failed to load asset.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.togglePeopleOcclusion()
    }

    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        togglePeopleOcclusion()
    }
    
    fileprivate func togglePeopleOcclusion() {
        guard let config = arView.session.configuration as? ARWorldTrackingConfiguration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        switch config.frameSemantics {
        case [.personSegmentationWithDepth]:
            config.frameSemantics.remove(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion off", duration: 1.0)
        default:
            config.frameSemantics.insert(.personSegmentationWithDepth)
            messageLabel.displayMessage("People occlusion on", duration: 1.0)
        }
        arView.session.run(config)
    }
}
