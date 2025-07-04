//
//  Font+.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import SwiftUI

///. | Figma 스타일 이름    | 굵기 (Weight) | 크기 (Size) | 줄 간격 (Line Height) | 용도 |
///. | `Headline/H1`     | Bold         | 28pt       | 36pt                | 중요한 화면의 제목        |
///. | `Headline/H2`     | Bold         | 22pt       | 28pt                | 섹션 제목               |
///. | `Headline/H3`     | SemiBold     | 18pt       | 24pt                | 카드, 리스트 제목         |
///. | `Body/B1-Regular` | Regular      | 16pt       | 24pt                | 가장 일반적인 본문         |
///. | `Body/B1-Bold`    | Bold         | 16pt       | 24pt                | 강조가 필요한 본문, 버튼     |
///. | `Body/B2-Regular` | Regular      | 14pt       | 20pt                | 보조적인 설명 텍스트         |
///. | `Caption/C1`      | Regular      | 12pt       | 16pt                | 아이콘 라벨, 가장 작은 텍스트 |
extension Font {
    enum FontType {
        case headlineH1
        case headlineH2
        case headlineH3
        case bodyB1Regular
        case bodyB1Bold
        case bodyB2Regular
        case captionC1
        
        var fontName: String {
            switch self {
            case .headlineH1, .headlineH2, .bodyB1Bold:
                return "Pretendard-Bold"
            case .headlineH3:
                return "Pretendard-SemiBold"
            case .bodyB1Regular, .bodyB2Regular, .captionC1:
                return "Pretendard-Regular"
            }
        }
        var size: CGFloat {
            switch self {
            case .headlineH1: return 28
            case .headlineH2: return 22
            case .headlineH3: return 18
            case .bodyB1Regular, .bodyB1Bold: return 16
            case .bodyB2Regular: return 14
            case .captionC1: return 12
            }
        }
        var lineHeight: CGFloat {
            switch self {
            case .headlineH1: return 36
            case .headlineH2: return 28
            case .headlineH3: return 24
            case .bodyB1Regular, .bodyB1Bold: return 24
            case .bodyB2Regular: return 20
            case .captionC1: return 16
            }
        }
    }
    
    static func custom(type: FontType) -> Font {
        return Font.custom(type.fontName, size: type.size)
    }
}
