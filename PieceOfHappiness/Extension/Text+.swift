//
//  Text+.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import Foundation
import SwiftUI

//extension Text {
//    func customFont(_ type: Font.FontType) -> Text {
//        var attr = AttributedString(self.verbatim)
//        attr.font = .custom(type.fontName, size: type.size)
//        var style = ParagraphStyle()
//        style.minimumLineHeight = type.lineHeight
//        style.maximumLineHeight = type.lineHeight
//        attr.paragraphStyle = style
//        return Text(attr)
//    }
//}

struct CustomFontWithLineHeight: ViewModifier {
    let type: Font.FontType
    
    func body(content: Content) -> some View {
        let attr = CustomFontWithLineHeight.attributedString(
            from: content,
            fontName: type.fontName,
            size: type.size,
            lineHeight: type.lineHeight
        )
        // content가 Text일 때만 적용
        if let text = Mirror(reflecting: content).descendant("storage", "anyTextStorage", "string") as? String {
            return AnyView(Text(attr))
        } else {
            // Text 이외는 그냥 font만 적용
            return AnyView(
                content.font(.custom(type.fontName, size: type.size))
            )
        }
    }
    
    static func attributedString(from content: Content, fontName: String, size: CGFloat, lineHeight: CGFloat) -> AttributedString {
        var attr = AttributedString(String(describing: content))
        attr.font = .custom(fontName, size: size)
        var style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        attr.paragraphStyle = style
        return attr
    }
}
