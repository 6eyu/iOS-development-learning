//
//  ContentView.swift
//  CustomCamera
//
//  Created by vliu on 25/2/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = ContentViewModel()
    @State private var zoom: CGFloat = 1
    let timer = Timer.TimerPublisher(interval: 0.95, runLoop: .main, mode: .default).autoconnect()

    var body: some View {
        ZStack {
            if model.isTaken, let image = model.capturedImage {
                
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                    .scaledToFill()
                    .frame(
                      width: geometry.size.width,
                      height: geometry.size.height,
                      alignment: .center)
                    .clipped()
                }
                
                    
            } else {
                FrameView(image: model.frame)
                  .edgesIgnoringSafeArea(.all)
            }
            

            
            VStack(spacing: 20) {
                Button {
                    model.takephoto()
                } label: {
                    Text("take")
                }
                
                Button {
                    model.retake()
                } label: {
                    Text("retale")
                }
                
//                Slider(value: $zoom, in: 1...2)
//                    .onChange(of: zoom) { newValue in
//                        model.zoomIn(newValue)
//
//                        print(newValue)
//                        print("\(model.minZoomFactor) - \(model.maxZoomFactor)")
//                    }
  
            }
            
        }
//        .onReceive(timer) { _ in
//            if model.frame != nil {
//                SwiftUICameraManager.shared.showInfo()
//            }
//        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
