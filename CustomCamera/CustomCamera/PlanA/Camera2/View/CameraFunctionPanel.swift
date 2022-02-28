//
//  CameraFunctionPanel.swift
//  SymbioticLabs
//
//  Created by vliu on 29/10/21.
//

import SwiftUI

struct CameraFunctionPanel: View {
    
    @Binding var isFlashOn: Bool
    @Binding var isFlashLightOn: Bool
    
    init(flashIndicator: Binding<Bool>, flashLightIndicator: Binding<Bool>) {
        self._isFlashOn = flashIndicator
        self._isFlashLightOn = flashLightIndicator
    }
    
    var body: some View {
        
        HStack(spacing: 20) {
            FunctionIcon(iconName: isFlashOn ? "bolt.fill" : "bolt.slash.fill", isOn: $isFlashOn)
            FunctionIcon(iconName: "flashlight.on.fill", isOn: $isFlashLightOn)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.2).clipShape(RoundedRectangle(cornerRadius:30)))
    }
}

struct FunctionIcon: View {
    
    let iconName: String
    @Binding var isOn: Bool
    
    init(iconName: String, isOn: Binding<Bool>) {
        self.iconName = iconName
        self._isOn = isOn
    }
    
    var body: some View {
        Button{
            self.isOn.toggle()
        } label: {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 12, height: 20)
                .foregroundColor( isOn ? Color.white : Color.gray)
        }
    }
}

//MARK: - Preview
struct CameraFunctionPanelTest: View {
    
    @State var flash = true
    @State var flashLight = false
    
    var body: some View {
        CameraFunctionPanel(flashIndicator: $flash, flashLightIndicator: $flashLight)
    }
}

struct CameraFunctionPanel_Previews: PreviewProvider {
    
    static var previews: some View {
        CameraFunctionPanelTest()
            .previewLayout(.sizeThatFits)

    }
}
