//
//  PieceDetailView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import SwiftUI
import ComposableArchitecture

struct PieceDetailView: View {
    let store: StoreOf<PieceDetail>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: store.date.isEmpty ? "저장된 Happiness 조회" : "\(store.date) Happiness",
                onLeftButtonTapped: {
                    store.send(.tapBackBtn)
                }
            )
            
            // 선택된 날짜 표시
            if !store.date.isEmpty {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    Text("선택된 날짜: \(store.date)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            if store.isLoading {
                Spacer()
                VStack {
                    ProgressView()
                    Text("Happiness 데이터를 불러오는 중...")
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                Spacer()
            } else if store.happinessList.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "face.dashed")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("저장된 Happiness가 없습니다")
                        .foregroundColor(.secondary)
                    Text("먼저 Register에서 데이터를 저장해보세요!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.happinessList, id: \.id) { happiness in
                            HappinessCard(
                                happiness: happiness,
                                hashtags: store.selectedHappiness?.id == happiness.id ? store.hashtags : [],
                                onTap: {
                                    store.send(.selectHappiness(happiness))
                                },
                                onDelete: {
                                    store.send(.deleteHappiness(happiness))
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            
            if let errorMessage = store.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

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

#Preview {
    PieceDetailView(store: Store(initialState: PieceDetail.State(), reducer: { PieceDetail() }))
}
