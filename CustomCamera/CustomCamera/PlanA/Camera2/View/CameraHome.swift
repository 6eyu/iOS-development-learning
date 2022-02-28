//
//  CameraHome.swift
//  ComplexSwiftUI
//
//  Created by vliu on 8/11/21.
//

import SwiftUI

struct CameraHome: View {
    
    @State var capturedImage: UIImage? = nil
    @State var isPresenting: Bool = false
    @State var test: String? = ""
    @State var photos: [Photo] = PhotoMockData.onePhoto//[]
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemBackground)
            
            List {
                ForEach(photos, id: \.self) { photo in
                    HStack {
                        Text(photo.photoType.getName())
                        Spacer()
                        if let photo = photo.image {
                            Image(uiImage: photo)
                                .resizable()
                                .frame(width: 50, height: 50)
                        } else {
                            Rectangle()
                                .frame(width: 50, height: 50)
                        }
                    }
                }
            }
            
            VStack {
                Spacer()

                Button {
                    isPresenting.toggle()
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.bottom)
                .sheet(isPresented: $isPresenting) {
                    CustomCameraView(
                        isPresenting: $isPresenting,
                        photos: $photos,
                        photoTypes: [.close_up, .standard, .reference]
                    )
                }
            }
        }
    }
}

struct CameraHome_Previews: PreviewProvider {
    static var previews: some View {
        CameraHome()
    }
}
