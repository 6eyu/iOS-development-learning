//
//  CameralMainControlPanel.swift
//  SymbioticLabs
//
//  Created by vliu on 29/10/21.
//

import SwiftUI

struct CameralMainControlPanel: View {
    
    typealias Action = () -> Void
    
    @Binding var isTaken: Bool
    
    let takeAction: Action
    let retakeAction: Action
    let saveAction: Action
    let dismissAction: Action
    
    init(isTaken: Binding<Bool>,takeAction: @escaping Action, retakeAction: @escaping Action, saveAction: @escaping Action, dismissAction: @escaping Action) {
        self.takeAction = takeAction
        self.retakeAction = retakeAction
        self.saveAction = saveAction
        self.dismissAction = dismissAction
        self._isTaken = isTaken
    }
    
    var body: some View {
        HStack {
            
            if self.isTaken {
                RetakeButton() {
                    retakeAction()
                }
                .offset(x: 35)
                
                SaveButton() {
                    saveAction()
                }
                
            } else {
                DismissButton() {
                    dismissAction()
                }
                .offset(x: 35)
                
                TakeButton() {
                    takeAction()
                }
            }

            Spacer()
                .frame(minWidth: 0, maxWidth: .infinity)

        }
    }
}

// MARK: - Buttons
struct DismissButton: View {
    
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button{
            action()
        } label: {
            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity)

    }
}

struct RetakeButton: View {
    
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button{
            action()
        } label: {
            
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .rotationEffect(.degrees(45))
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.red)
            }

        }
        .frame(minWidth: 0, maxWidth: .infinity)

    }
}


struct TakeButton: View {
    
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button{
            action()
        } label: {
           ZStack {
               Circle()
                   .fill(Color.white)
                   .frame(width: 63, height: 63)

               Circle()
                   .stroke(Color.white, lineWidth: 4)
                   .frame(width: 75, height: 75)
           }
        }
        .frame(minWidth: 0, maxWidth: .infinity)

    }
}

struct SaveButton: View {
    
    let action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button{
            action()
        } label: {
           ZStack {
               Circle()
                   .fill(Color.white)
                   .frame(width: 63, height: 63)
               
               Image(systemName: "checkmark.circle.fill")
                   .resizable()
                   .frame(width: 63, height: 63)
                   .foregroundColor(Color.green)

               Circle()
                   .stroke(Color.white, lineWidth: 4)
                   .frame(width: 75, height: 75)
           }
        }
        .frame(minWidth: 0, maxWidth: .infinity)

    }
}

// MARK: - Preview

struct CameralMainControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        CameralMainControlPanel(
            isTaken: .constant(false),
            takeAction: {},
            retakeAction: {},
            saveAction: {},
            dismissAction: {}
        )
    }
}
