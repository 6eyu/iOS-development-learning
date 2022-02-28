//
//  CameraService.swift
//  ComplexSwiftUI
//
//  Created by vliu on 8/11/21.
//

import SwiftUI
import Foundation
import AVFoundation

//protocol

class CameraService:NSObject, ObservableObject {
    
    typealias Completion = (Error?) -> ()

    var session = AVCaptureSession()
    weak var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping Completion ) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping Completion) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                    guard granted else { return }
                    
                    DispatchQueue.main.async {
                        self.setupCamera(completion: completion)
                    }
                        
                }
            case .denied, .restricted:
                break
            case .authorized:
                setupCamera(completion: completion)
            default: break
        }
    }
    
    private func setupCamera(completion: @escaping Completion) {
        //let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                startRunningCaptureSession()
                //self.session = session
            } catch {
                completion(error)
            }
        }
    }
    
    func startRunningCaptureSession() {
        session.startRunning()
    }
    
    func stopRunningCaptureSession() {
        session.stopRunning()
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
}

