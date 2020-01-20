//
//  ViewController.swift
//  LightTest
//
//  Created by iOS1920 on 17.01.20.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit
import AVFoundation
import RealityKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {

    var lightEstimate: CGFloat = 0
    
    let session = ARSession()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runARSessionForLightEstimate()
    }

    @IBAction func ButtonTouch(_ sender: Any) {        
        
        let temp = (session.currentFrame?.lightEstimate!.ambientColorTemperature)!
        let intensity = (session.currentFrame?.lightEstimate!.ambientIntensity)!
        print("Temp: \(temp)")
        print("Intensity: \(intensity)")
    }
    
    
    func runARSessionForLightEstimate() {
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = true
        session.run(config)
        session.delegate = self
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("Update 1")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("Update 2")
    }
    
    
//    func takePhoto() {
//        // Capture Session
//        let captureSession = AVCaptureSession()
//
//        captureSession.beginConfiguration()
//        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
//
//        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device!),
//            captureSession.canAddInput(videoDeviceInput)
//            else {
//                print("Error 1")
//                return }
//        captureSession.addInput(videoDeviceInput)
//
//        // PhotoOutPut
//        let photoOutput = AVCapturePhotoOutput()
//
//        guard captureSession.canAddOutput(photoOutput) else {
//            print("Error 2")
//            return }
//        captureSession.sessionPreset = .photo
//        captureSession.addOutput(photoOutput)
//        captureSession.commitConfiguration()
//
//        // Start Session
//        captureSession.startRunning()
//
//        // PhotoSettings
//        let photoSettings: AVCapturePhotoSettings
//        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
//            photoSettings = AVCapturePhotoSettings(format:
//                [AVVideoCodecKey: AVVideoCodecType.hevc])
//        } else {
//            photoSettings = AVCapturePhotoSettings()
//        }
//        photoSettings.flashMode = .off
//
//        let captureProcessor = PhotoCaptureProcessor()
//        photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)
//
//        // Do any additional setup after loading the view.
//    }
}

//class PhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//        output.
//    }
//}
