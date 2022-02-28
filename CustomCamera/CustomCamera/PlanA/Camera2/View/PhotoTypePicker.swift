//
//  PhotoTypePicker.swift
//  SymbioticLabs
//
//  Created by vliu on 29/10/21.
//

import SwiftUI

/// A horizontal scroll picker
/// ```
///    var items: [PhotoType] = [.close_up, .reference, .standard]
///    @State var index = 0
///    var body: some View {
///         VStack {
///             PhotoTypePicker(selected: $index, items: items) { item, isSelected in
///                 Text(item.display)
///                     .foregroundColor( isSelected ? .yellow : nil)
///                     .font(.caption)
///             }
///         }
///    }
/// ```
struct PhotoTypePicker<Content: View, T: RawRepresentable>: View {
    
    typealias ItemView = (T, Bool) -> Content
    
    let list: [T]
    let content: ItemView
    let spacing: CGFloat
    var adjustLv: CGFloat
    
    @State var onChanged: Int
    @GestureState var offset: CGFloat = 0

    @Binding var selected: Int

    init(spacing: CGFloat = 8, adjustLv: CGFloat = 4, selected: Binding<Int>, items: [T], @ViewBuilder content: @escaping ItemView) {
        
        self.spacing = spacing
        self.adjustLv = adjustLv
        self.list = items
        self.content = content
        
        self._selected = selected
        self._onChanged = State(initialValue: selected.wrappedValue)
        
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            let adjustmentWidth = geometryProxy.size.width / adjustLv
            
            VStack {
                HStack(spacing: spacing) {
                    ForEach(list.indices, id: \.self) { index in
//                        content(list[index], onChanged == index)
//                            .frame(width: 90)
                        content(list[index], selected == index)
                            .frame(width: 90)
                    }
                }
                .offset(x: (CGFloat(selected) * -adjustmentWidth) + adjustmentWidth + offset)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { value, out, _ in
                            out = value.translation.width
                        })
                        .onChanged({ value in
                            let roundIndex = (-value.translation.width / adjustmentWidth).rounded()
                            onChanged = max(min(selected + Int(roundIndex), list.count - 1), 0)
                        })
                        .onEnded({ _ in
                            selected = onChanged
                        })
                )
            }
            .position(x: geometryProxy.frame(in: .local).midX, y: geometryProxy.frame(in: .local).midY)
        }
    }


}


//// MARK: - Preview
//struct PhotoTypePickerTest: View {
//    var items: [PhotoType] = [.close_up, .reference, .standard]
//    @State var index = 0
//
//    var body: some View {
//        VStack {
//            PhotoTypePicker(selected: $index, items: items) { item, isSelected in
//                Text(item.display)
//                    .foregroundColor( isSelected ? .yellow : nil)
//                    .font(.caption)
//            }
//        }
//    }
//}
//
//struct PhotoTypePicker_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PhotoTypePickerTest()
//    }
//}
