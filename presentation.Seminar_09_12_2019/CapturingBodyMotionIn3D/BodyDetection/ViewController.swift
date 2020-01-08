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
//    var character: BodyTrackedEntity?
    let numOfCharacters = 2

    // array for 4 different robots to give them a new x-position
    let xs = [-1.2, -0.6, 0.6 , 1.2]
    //Body tracked entity which the robot.usdz is loaded into
    var characters: Array<BodyTrackedEntity> = []
    // the position of the robot offset from the origin measuring point
    var characterOffsets: Array<SIMD3<Float>> = []
    // Anchor which the BodyTrackedEntity is add to an Anchor
    var characterAnchors: Array<AnchorEntity> = []
 
    //Only runs when app view is shown. So when app is turned on and when app is reopened
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        characterAnchors = Array(repeating: AnchorEntity(), count: self.numOfCharacters)
        characterOffsets = Array(repeating: [1.0, 0, 0], count: self.numOfCharacters)
        
        for  i in 0...self.numOfCharacters-1{
            characterAnchors[i] = AnchorEntity()
            arView.scene.addAnchor(characterAnchors[i])
        }
        
        var cancellable: AnyCancellable? = nil
        // Using a Publisher/Subscriber to receive and send data more safely.
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
            },
            receiveValue: { (character: Entity) in
                //check if character is a BodyTrackedEntity
                if let character = character as? BodyTrackedEntity {
                    character.scale = [1.0, 1.0, 1.0]
                    //Make space in memory that matches the size of the respective BodyTrackedEntity
                    self.characters = Array(repeating: character.clone(recursive: true), count: self.numOfCharacters)

                    //Populate array with newly filled space in memory
                    for  i in 0...self.numOfCharacters - 1{
                        let x : Float = Float(i)-0.6
//                        let z : Float = Float(i / 4) + 0.25
                        //clone() is used to copy by value and not by reference to create new copies of the object
                        self.characters[i] = character.clone(recursive: true)
                        self.characterOffsets[i] = [x, 0, 0]
                    }

                    cancellable?.cancel()
                } else {
                    print("Error: Unable to load model as BodyTrackedEntity")
                }
            }
        )
    }
    
    //session that updates to position of body that is being following as it is tracked
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)

            // updating every entity in array and their respective anchors
            for  i in 0...self.numOfCharacters - 1{
                //update Anchor position
                characterAnchors[i].position = bodyPosition + characterOffsets[i]
                //update Anchor orientation
                characterAnchors[i].orientation = Transform(matrix: bodyAnchor.transform).rotation

                //checking if all entities in array are full
                if characters[i].parent == nil {
                    characterAnchors[i].addChild(characters[i])
                    
                }
            }
        }
    }
    
    //NOTE: Unrelated code to demo but was used to show how to extract data from the 2D skeleton
    // Accessing Data from 2D Skeleton
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//
//        let person = frame.detectedBody!
//
//        let skeleton2D = person.skeleton
//
//        let definition = skeleton2D.definition
//
//        let jointLandmarks = skeleton2D.jointLandmarks
//
//        for (i, joint) in jointLandmarks.enumerated() {
//
//            let parentIndex = definition.parentIndices[i]
//
//            guard parentIndex != -1 else { continue }
//
//            let parentJoint = jointLandmarks[parentIndex]
//        }
//    }
}
