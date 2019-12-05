/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
    // The 3D character to display.
    var character1: BodyTrackedEntity?
    var character2: BodyTrackedEntity?
    
    let characterOffset1: SIMD3<Float> = [-1.0, 0, 0] // Offset the character by one meter to the left
    let characterOffset2: SIMD3<Float> = [1.0, 0, 0] // Offset the character by one meter to the right
    
    let characterAnchor1 = AnchorEntity()
    let characterAnchor2 = AnchorEntity()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        let configuration = ARBodyTrackingConfiguration()
        arView.debugOptions = [.showAnchorGeometry, .showAnchorOrigins, .showFeaturePoints, .showPhysics]
        arView.session.run(configuration)
        arView.scene.addAnchor(characterAnchor1)
        arView.scene.addAnchor(characterAnchor2)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
            }, receiveValue: { (receiveValue: Entity) in
                if let receiveValue = receiveValue as? BodyTrackedEntity {
                    // Scale the character to human size
                    receiveValue.scale = [1.0, 1.0, 1.0]
                    self.character1 = receiveValue
                    self.character2 = receiveValue
                    cancellable?.cancel()
                } else {
                    print("Error: Unable to load model as BodyTrackedEntity")
                }
            })
        
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }

            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor1.position = bodyPosition + characterOffset1
            characterAnchor2.position = bodyPosition + characterOffset2
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor1.orientation = Transform(matrix: bodyAnchor.transform).rotation
            characterAnchor2.orientation = Transform(matrix: bodyAnchor.transform).rotation
   
            if (character1!.parent == nil) && (character2!.parent == nil) {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor1.addChild(character1!)
                characterAnchor2.addChild(character2!)
            }
            
            
            // Extracting Data from 3D Skeleton
            
            // Access to the Position of Root Node
            let hipWorldPosition = bodyAnchor.transform
            // Accessing the Skeleton Geometry
            let skeleton = bodyAnchor.skeleton
            // Accessing List of Transforms of all Joints Relative to Root
            let jointTransforms = skeleton.jointModelTransforms
            // Iterating over ALL Joints
            for (i, jointTransform) in jointTransforms.enumerated() {
                // Extract Parent Index from Definition
                let parentIndex = skeleton.definition.parentIndices[i]
                // Check if it's not the Root
                guard parentIndex != -1 else { continue }
                // Find Position of Parent Joint
                let parentJointTransform = jointTransforms[parentIndex]
            }
        }
    }
    
    // Extracting Data from 2D Skeleton
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Accessing ARBody2D Object from ARFrame
        let person = frame.detectedBody!
        // Use Skeleton Property to Access the Skeleton
        let skeleton2D = person.skeleton
        // Access Definition Object Containing Structure
        let definition = skeleton2D.definition
        // List of Joint Landmarks
        let jointLandmarks = skeleton2D.jointLandmarks
        // Iterate over ALL the Landmarks
        for (i, joint) in jointLandmarks.enumerated() {
            // Find Index of Parent
            let parentIndex = definition.parentIndices[i]
            // Check if it's not the Root
            guard parentIndex != -1 else { continue }
            // Find Position of Parent Index
            let parentJoint = jointLandmarks[parentIndex]
        }
    }
}


