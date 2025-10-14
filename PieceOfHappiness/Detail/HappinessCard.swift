import SwiftUI

struct HappinessCard: View {
    let happiness: Happiness
    let hashtags: [HashTag]
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 제목, 날짜, 삭제 버튼
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(happiness.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(happiness.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            // 메시지
            Text(happiness.message)
                .font(.body)
                .lineLimit(nil)
            
            // 이미지 경로들
            if !happiness.imagePath.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("이미지:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(happiness.imagePath, id: \.self) { imagePath in
                        Text("📸 \(imagePath)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // 해시태그들
            if !hashtags.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("해시태그:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 4) {
                        ForEach(hashtags, id: \.id) { hashtag in
                            Text(hashtag.content)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // 탭해서 해시태그 로드 안내
            if hashtags.isEmpty && happiness.id != nil {
                Text("탭해서 해시태그 보기")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
    }
}
