//
//  ContentViewModel.swift
//  CustomCamera
//
//  Created by vliu on 25/2/2022.
//

import CoreImage
import VideoToolbox
import UIKit

class ContentViewModel: ObservableObject {
 
    @Published var frame: CGImage?
    @Published var capturedImage: UIImage?
    @Published var isTaken: Bool = false
    
    private let frameManager = FrameManager.shared

//    var maxZoomFactor: CGFloat {
//        get {
//            SwiftUICameraManager.shared.maxZoomFactor
//        }
//    }
//    
//    var minZoomFactor: CGFloat {
//        get {
//            SwiftUICameraManager.shared.minZoomFactor
//        }
//    }

    init() {
        setupSubscriptions()
    }

    func setupSubscriptions() {
      frameManager.$current
        .receive(on: RunLoop.main)
        .compactMap { buffer in
            return CGImage.create(from: buffer)
        }
        .assign(to: &$frame)
    }
    
    func takephoto() {
        guard let cgimage = frame else { return }
        
        capturedImage = UIImage(cgImage: cgimage)
        
        isTaken = true
    }
    
    func retake() {
        isTaken = true
        capturedImage = nil
    }
    
    func zoomIn(_ scale: CGFloat) {
//        SwiftUICameraManager.shared.zoom(scale)
    }
    
}

extension CGImage {
    static func create(from pixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let buffer = pixelBuffer else { return nil }
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(buffer, options: nil, imageOut: &cgImage)
        return cgImage
    }
}
