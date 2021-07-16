//
//  UtilityViews.swift
//  EmojiArt
//
//  Created by vliu on 10/7/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}
