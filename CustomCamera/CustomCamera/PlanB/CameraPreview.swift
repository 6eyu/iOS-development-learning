//
//  CameraPreview.swift
//  SymbioticLabs
//
//  Created by vliu on 17/10/21.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var cameraViewModel: CameraViewModel
    
    init(_ viewModel: CameraViewModel) {
        self.cameraViewModel = viewModel
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        // Provide a camera preview
        cameraViewModel.preview = AVCaptureVideoPreviewLayer(session: cameraViewModel.captureSession)
        cameraViewModel.preview.frame = view.frame
        cameraViewModel.preview.videoGravity = .resizeAspectFill
        print("CameraPreview makeUIView - \(cameraViewModel.preview)")
        view.layer.addSublayer(cameraViewModel.preview)
        
        //cameraViewModel.captureSession.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
