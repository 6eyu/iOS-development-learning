//
//  PhotoMockData.swift
//  CameraTestProject
//
//  Created by Chris Chong on 14/12/21.
//

import Foundation

struct PhotoMockData {
    
    static let onePhoto = [
        Photo(id: UUID().uuidString, photoType: .reference, image: nil)
    ]
    
    static let twoPhotos = [
        Photo(id: UUID().uuidString, photoType: .close_up, image: nil),
        Photo(id: UUID().uuidString, photoType: .standard, image: nil)
    ]
    
    static let threePhotos = [
        Photo(id: UUID().uuidString, photoType: .close_up, image: nil),
        Photo(id: UUID().uuidString, photoType: .standard, image: nil),
        Photo(id: UUID().uuidString, photoType: .reference, image: nil)
    ]
}
