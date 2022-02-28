//
//  FrameView.swift
//  CustomCamera
//
//  Created by vliu on 25/2/2022.
//

import SwiftUI

struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("Camera feed")
    
    var body: some View {
        if let image = image {
          GeometryReader { geometry in
              Image(image, scale: 1.0, label: label)
              .resizable()
              .scaledToFill()
              .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center)
              .clipped()
          }
        } else {
          Color.black
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
