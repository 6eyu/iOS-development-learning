//
//  CustomCameraView.swift
//  ComplexSwiftUI
//
//  Created by vliu on 8/11/21.
//

import SwiftUI
import Vision

struct CustomCameraView: View {
    
    @Binding var isPresenting: Bool
    @StateObject var cameraManager: CameraManager
    @Binding var photos: [Photo]
    
    init(isPresenting: Binding<Bool>, photos: Binding<[Photo]>, photoTypes: [PhotoType]) {
        _isPresenting = isPresenting
        _photos = photos

        self._cameraManager = StateObject(wrappedValue: CameraManager(photoTypes, photos.wrappedValue))
    }
    
    var body: some View {
        
        ZStack {
            if let capturedImage = cameraManager.image {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            } else {
                CameraViewA(cameraService: cameraManager.cameraService) { result in
                    switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let photo):
                            if let data = photo.fileDataRepresentation() {
                                
                                //self.isPresenting.toggle()
                                //analyze(UIImage(data: data)!)
                                self.cameraManager.image = UIImage(data: data)
                                //print("CameraView - new image - \(data)")
                            } else {
                                print("Error: No Image data")
                            }
                    }
                }
            }
            VStack {
                Spacer()
                //
                CameraFunctionPanel(flashIndicator: $cameraManager.isFlashAutoOn, flashLightIndicator: $cameraManager.isFlashLightOn)

                VStack {

                    if cameraManager.isSamplePhoto {
                        PhotoTypePicker(selected: $cameraManager.selectedIndex, items: cameraManager.types) { item, isSelected in
                            VStack {
                                Text(item.rawValue)
                                    .foregroundColor( isSelected ? .yellow : .white)
                                    .font(.caption)
                                Capsule()
                                    .frame(height: 4)
                                    .foregroundColor(isSelected ? .yellow: .clear)
                            }
                        }
                        .frame(height: 50)
                    }

                    CameralMainControlPanel(
                        isTaken: $cameraManager.isTaken,
                        takeAction: cameraManager.takePicture,
                        retakeAction: cameraManager.retakePicture,
                        saveAction: cameraManager.savePicture,
                        dismissAction: {
                            print("dismiss camera")
                            self.isPresenting = false
                        }
                    )

                    if cameraManager.isSamplePhoto {
                        Spacer()
                    }
                }
                .frame(height: 180)
                .background(Color.black.opacity(0.5))
            }
            .ignoresSafeArea(.all, edges: .bottom)

        }
        .onReceive(cameraManager.$photos) { photos in
            self.photos = photos
            print("Photos are updated - ", photos)
        }
        .onDisappear {
            cameraManager.cameraService.stopRunningCaptureSession()
        }
    }
    
    
    func analyze(_ image: UIImage) {

        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("no result ... ")

                return
            }
            print("analyze...")

            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            
            DispatchQueue.main.async {
                //self.test = text
            }
            print(text)
            
        }
        
        do {
            print("start analyze image")

            try handler.perform([request])
            
            print("end analyze image")

        } catch {
            print(error)
        }
        
    }
    
    func getCGOrientationFromUIImage(_ image: UIImage) -> CGImagePropertyOrientation {
        // returns que equivalent CGImagePropertyOrientation given an UIImage.
        // This is required because UIImage.imageOrientation values don't match to CGImagePropertyOrientation values
        switch image.imageOrientation {
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        case .up:
            return .up
        case .downMirrored:
            return .downMirrored
        case .leftMirrored:
            return .leftMirrored
        case .rightMirrored:
            return .rightMirrored
        case .upMirrored:
            return .upMirrored
        }
    }
}
