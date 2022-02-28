//
//  PhotoType.swift
//  CameraTestProject
//
//  Created by Chris Chong on 9/12/21.
//

import Foundation

enum PhotoType: String {
    case reference
    case standard
    case close_up
    
    func isStandard() -> Bool {
        return self == PhotoType.standard
    }
    
    func isReference() -> Bool {
        return self == PhotoType.reference
    }
    
    func isCloseUp() -> Bool {
        return self == PhotoType.close_up
    }
    
    func getName() -> String {
        switch self {
        case .reference:
            return "REFERENCE"
        case .close_up:
            return "CLOSE_UP"
        case .standard:
            return "STANDARD"
        }
    }
}
