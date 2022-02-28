//
//  CameraManager.swift
//  CameraTestProject
//
//  Created by Chris Chong on 9/12/21.
//

import Foundation
import SwiftUI

class CameraManager: ObservableObject {
    
    @Published var isTaken: Bool = false
    @Published var isFlashAutoOn: Bool = true
    @Published var isFlashLightOn: Bool = false
    @Published var isSaved: Bool = false
    @Published var alert: Bool = false
    
    let cameraService = CameraService()
    let types: [PhotoType]

    @Published var photos: [Photo] = []
    
    @Published var image: UIImage?
    
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
    
    init(_ photoTypes: [PhotoType],_ photos: [Photo]) {
        print("CameraManager - Init")
        self.types = photoTypes
        self.photos = photos
        
        setupSelectedPhotoType()
    }
    
    deinit {
        print("CameraManager - Deinit")
    }
    
}

extension CameraManager {
    
    func setupSelectedPhotoType() {
        //Determine the selectedIndex, reset to 0 if there are none present or photos are full
        if photos.isEmpty {
            self.selectedIndex = 0
        } else if photos.count >= 3 {
            self.selectedIndex = 1
        } else {
            let arr = photos.map { $0.photoType }
            if let diff = types.difference(from: arr).insertions.first {
                switch diff {
                case let .insert(offset: index, element: _, associatedWith: _):
                    self.selectedIndex = index
                    break
                default:
                    break

                }
            }
        }
    }
    
}

extension CameraManager {
    
    func takePicture() {
        print("takePicture")
        cameraService.capturePhoto()
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken.toggle()
            }
        }
    }
    
    func retakePicture() {
        print("retakePicture")
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken.toggle()
                self.isSaved = false
                self.image = nil
            }
        }
    }
    
    func savePicture() {
        print("savePicture - image")
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken.toggle()
                self.isSaved = true
                
                print("photoType - \(self.currentPhotoType), image - \(self.image)")
                self.photos.append(Photo(id: UUID().uuidString, photoType: self.currentPhotoType, image: self.image))
                self.setupSelectedPhotoType()
                self.image = nil
            }
        }
    }
    
}
