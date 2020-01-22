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
    var running: Bool = false
    let session = ARSession()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runARSessionForLightEstimate()
    }

    @IBAction func ButtonTouch(_ sender: Any) {        
        if(running) {
            session.pause()
            running = false
        }
        else {
            let config = ARFaceTrackingConfiguration()
            
            config.isLightEstimationEnabled = true
            config.videoFormat = ARFaceTrackingConfiguration.supportedVideoFormats.last!
            session.run(config)
            
            running = true
        }
        
    }
    
    
    func runARSessionForLightEstimate() {
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        session.delegate = self
        
        let config = ARFaceTrackingConfiguration()
        
        config.isLightEstimationEnabled = true
        config.videoFormat = ARFaceTrackingConfiguration.supportedVideoFormats.last!
        session.run(config)
        
        running = true
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let temp = frame.lightEstimate!.ambientColorTemperature
        let intensity = frame.lightEstimate!.ambientIntensity
        print("Temp: \(temp) Intensity: \(intensity)")
        
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
