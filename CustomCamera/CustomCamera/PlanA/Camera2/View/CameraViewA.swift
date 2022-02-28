//
//  CameraViewA.swift
//  ComplexSwiftUI
//
//  Created by vliu on 8/11/21.
//

import SwiftUI
import AVFoundation

struct CameraViewA: UIViewControllerRepresentable {
    
    typealias AVCapturePhotoResult = (Result<AVCapturePhoto, Error>) -> ()
    
    @ObservedObject var cameraService: CameraService
    
    let didFinishProcessingPhoto: AVCapturePhotoResult
    
    func makeUIViewController(context: Context) -> some UIViewController {
        print("makeUIViewController")
        cameraService.start(delegate: context.coordinator) { error in
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
        }
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("updateUIViewController")
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraViewA
        private var didFinishProcessingPhoto: AVCapturePhotoResult

        
        init(_ parent: CameraViewA, didFinishProcessingPhoto: @escaping AVCapturePhotoResult) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
    }
}
