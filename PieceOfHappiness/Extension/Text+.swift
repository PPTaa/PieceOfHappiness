//
//  Text+.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import Foundation
import SwiftUI

struct FontModifier: ViewModifier {
    let fontType: Font.FontType
    let color: Color
    
    func body(content: Content) -> some View {
        let font = UIFont(name: fontType.fontName, size: fontType.size) ?? .systemFont(ofSize: fontType.size)
        let currentLineHeight = font.lineHeight
        let requiredSpacing = fontType.lineHeight - currentLineHeight
        
        content
            .font(.custom(type: fontType))
            .lineSpacing(requiredSpacing)
            .padding(.vertical, (fontType.lineHeight - currentLineHeight) / 2)
            .foregroundColor(color)
    }
}

extension Text {
    func appFont(_ fontType: Font.FontType, color: Color = .primary) -> some View {
        modifier(FontModifier(fontType: fontType, color: color))
    }
}
