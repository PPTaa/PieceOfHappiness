//
//  HashTagDisplayView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 11/4/25.
//

import SwiftUI

/// 해시태그를 표시하는 읽기 전용 뷰
struct HashTagDisplayView: View {
    let hashtags: [HashTag]
    let style: DisplayStyle
    
    enum DisplayStyle {
        case compact  // 작은 칩 형태
        case normal   // 일반 칩 형태
        case large    // 큰 칩 형태
        
        var fontSize: Font {
            switch self {
            case .compact: return .caption
            case .normal: return .subheadline
            case .large: return .body
            }
        }
        
        var padding: (horizontal: CGFloat, vertical: CGFloat) {
            switch self {
            case .compact: return (6, 4)
            case .normal: return (12, 6)
            case .large: return (16, 8)
            }
        }
    }
    
    init(hashtags: [HashTag], style: DisplayStyle = .normal) {
        self.hashtags = hashtags
        self.style = style
    }
    
    var body: some View {
        if hashtags.isEmpty {
            EmptyView()
        } else {
            FlowLayout(spacing: 8) {
                ForEach(hashtags, id: \.id) { hashtag in
                    HashTagChipView(
                        text: hashtag.content,
                        style: style
                    )
                }
            }
        }
    }
}

/// 개별 해시태그 칩 뷰 (읽기 전용)
struct HashTagChipView: View {
    let text: String
    let style: HashTagDisplayView.DisplayStyle
    
    var body: some View {
        Text(text)
            .font(style.fontSize)
            .foregroundColor(.blue)
            .padding(.horizontal, style.padding.horizontal)
            .padding(.vertical, style.padding.vertical)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        // Compact 스타일
        VStack(alignment: .leading) {
            Text("Compact Style")
                .font(.headline)
            HashTagDisplayView(
                hashtags: [
                    HashTag(content: "#행복"),
                    HashTag(content: "#좋은하루"),
                    HashTag(content: "#감사"),
                    HashTag(content: "#친구들과함께")
                ],
                style: .compact
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        
        // Normal 스타일
        VStack(alignment: .leading) {
            Text("Normal Style")
                .font(.headline)
            HashTagDisplayView(
                hashtags: [
                    HashTag(content: "#행복"),
                    HashTag(content: "#좋은하루"),
                    HashTag(content: "#감사"),
                    HashTag(content: "#친구들과함께")
                ],
                style: .normal
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        
        // Large 스타일
        VStack(alignment: .leading) {
            Text("Large Style")
                .font(.headline)
            HashTagDisplayView(
                hashtags: [
                    HashTag(content: "#행복"),
                    HashTag(content: "#좋은하루"),
                    HashTag(content: "#감사")
                ],
                style: .large
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    .padding()
}
