//
//  CameraViewModel.swift
//  SymbioticLabs
//
//  Created by vliu on 16/10/21.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit

class CameraViewModel: NSObject, CameraProtocol, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken: Bool = false
    @Published var isFlashAutoOn: Bool = true
    @Published var isFlashLightOn: Bool = false
    @Published var isSaved: Bool = false
    @Published var alert: Bool = false
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var captureSession: AVCaptureSession = AVCaptureSession()
    @Published var output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    @Published var image: UIImage?
    
    let types: [PhotoType]
    
    @Published var selectedIndex: Int = 0
    
    var isSamplePhoto: Bool {
        get {
            return types.count > 1
        }
    }
    
    var currentPhotoType: PhotoType {
        get {
            return types[selectedIndex]
        }
    }
    
    init(_ photoTypes: [PhotoType]) {
        print("CameraViewModel - Init")
        self.types = photoTypes
    }
    
    deinit {
        print("CameraViewModel - Deinit")
    }
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setUp()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { status in
                    if status {
                        self.setUp()
                    }
                }
            case .denied:
                self.alert.toggle()
            default: return
        }
    }
    
    func setUp() {
        do {
            self.captureSession.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {
                print("Error  - AVCaptureDevice.default")
                return
            }
            //AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                print("Error - AVCaptureDeviceInput")
                return
            }
            
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
            }
            
            if self.captureSession.canAddOutput(self.output) {
                self.captureSession.addOutput(self.output)
            }
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        } catch {
            print("Setup - Error - \(error.localizedDescription)")
        }
    }
    
    func takePicture() {
        print("takePicture start------------")

        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.captureSession.stopRunning()
            print("takePicture done ------------")
            DispatchQueue.main.async {
//                withAnimation {
                    self.isTaken.toggle()
//                }
            }
        }
    }
    
    func retakePicture() {
        print("retakePicture start------------")

        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
//                withAnimation {
                self.isTaken.toggle()
                self.image = nil

//                    self.isSaved = false
//                }
            }
        }
        print("retakePicture end------------")

    }
    
    func savePicture() {
//        if let image  = UIImage(data: self.pictureData) {
//            print("savePicture - image - \(image)")
//    //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//            self.isSaved = true
//        } else {
//            print("savePicture - empty image")
//        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("willCapturePhotoFor - \(resolvedSettings)")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("didCapturePhotoFor - \(resolvedSettings)")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            print("photoOutput error - \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        print("Picture was taken - \(imageData)")
//        self.pictureData = imageData
        
        self.image = UIImage(data: imageData)
    }
    

}
