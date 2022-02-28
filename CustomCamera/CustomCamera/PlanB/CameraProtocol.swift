//
//  CameraProtocol.swift
//  SymbioticLabs
//
//  Created by vliu on 29/10/21.
//

import Foundation

protocol CameraProtocol: ObservableObject {
    func takePicture()
    func savePicture()
    func retakePicture()
}

