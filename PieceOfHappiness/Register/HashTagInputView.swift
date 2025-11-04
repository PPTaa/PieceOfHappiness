//
//  HashTagInputView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 11/4/25.
//

import SwiftUI
import ComposableArchitecture

struct HashTagInputView: View {
    @Bindable var store: StoreOf<PieceRegister>
    @State private var hashTagInput: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("해시태그")
                .font(.headline)
                .foregroundColor(.primary)
            
            // 해시태그 입력 필드
            HStack {
                TextField("#해시태그 입력", text: $hashTagInput)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        addHashTag()
                    }
                
                Button(action: addHashTag) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .disabled(hashTagInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // 해시태그 목록 표시
            if !store.hashTags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("추가된 해시태그")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(store.hashTags.indices, id: \.self) { index in
                            HashTagChip(
                                text: store.hashTags[index].content,
                                onDelete: {
                                    removeHashTag(at: index)
                                }
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    private func addHashTag() {
        var trimmed = hashTagInput.trimmingCharacters(in: .whitespaces)
        
        // 해시태그 형식으로 변환
        if !trimmed.isEmpty {
            if !trimmed.hasPrefix("#") {
                trimmed = "#" + trimmed
            }
            
            // 중복 체크
            if !store.hashTags.contains(where: { $0.content == trimmed }) {
                var newHashTags = store.hashTags
                newHashTags.append(HashTag(content: trimmed))
                store.send(.hashTagsChanged(newHashTags))
                hashTagInput = ""
            }
        }
    }
    
    private func removeHashTag(at index: Int) {
        var newHashTags = store.hashTags
        newHashTags.remove(at: index)
        store.send(.hashTagsChanged(newHashTags))
    }
}

// 해시태그 칩 컴포넌트
struct HashTagChip: View {
    let text: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue)
        .cornerRadius(16)
    }
}

// FlowLayout - 해시태그를 자동으로 줄바꿈하여 표시
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                     y: bounds.minY + result.frames[index].minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    // 다음 줄로 이동
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    HashTagInputView(
        store: Store(
            initialState: PieceRegister.State(date: "2024-11-04"),
            reducer: { PieceRegister() }
        )
    )
    .padding()
}
