//
//  CameraScreen.swift
//  SymbioticLabs
//
//  Created by vliu on 16/10/21.
//

import SwiftUI

struct CameraScreen: View {
    
    @StateObject var viewModel: CameraViewModel
    //@ObservedObject var viewModel: CameraViewModel
    init(photoTypes: [PhotoType]) {
        self._viewModel = StateObject(wrappedValue: CameraViewModel(photoTypes))
        //self.viewModel = CameraViewModel(photoTypes)
    }

    var body: some View {
    
        ZStack(alignment: .bottom) {
            
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .ignoresSafeArea(.all, edges: .all)
                        .zIndex(viewModel.isTaken ? 0 : -1)
                }
            
                CameraPreview(viewModel)
                    .ignoresSafeArea(.all, edges: .all)
                    .zIndex(viewModel.isTaken ? -1 : 0)
            
           
                        
            VStack {
                Spacer()
//                CameraFunctionPanel(flashIndicator: $viewModel.isFlashAutoOn, flashLightIndicator: $viewModel.isFlashLightOn)
                
                VStack {
                    
                    if viewModel.isSamplePhoto {
                        PhotoTypePicker(selected: $viewModel.selectedIndex, items: viewModel.types) { item, isSelected in
                            Text(item.rawValue)
                                .foregroundColor( isSelected ? .yellow : .white)
                                .font(.caption)
                        }
                        .frame(height: 50)
                    }
                    
                    HStack {
                        
                        if viewModel.isTaken {
                            RetakeButton() {
                                viewModel.retakePicture()
                            }
                            .offset(x: 35)
                            
                            SaveButton() {
                                viewModel.savePicture()
                            }
                            
                        } else {
                            DismissButton() {
//                                dismissAction()
                            }
                            .offset(x: 35)
                            
                            TakeButton() {
                                viewModel.takePicture()
                            }
                        }

                        Spacer()
                            .frame(minWidth: 0, maxWidth: .infinity)

                    }

//                    CameralMainControlPanel(cameraViewModel: viewModel, isTaken: $viewModel.isTaken) {
//                        print()
//                    }
                    
                    if viewModel.isSamplePhoto {
                        Spacer()
                    }
                }
                .frame(height: 180)
                .background(Color.black.opacity(0.5))
                .zIndex(1)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }.onAppear {
            viewModel.check()
        }
    }
}
