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
                VStack(spacing: 20) {
                    Image(systemName: "face.dashed")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("저장된 Happiness가 없습니다")
                        .foregroundColor(.secondary)
                    Text("먼저 Register에서 데이터를 저장해보세요!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Happiness 추가하기 버튼
                    Button(action: {
                        store.send(.tapRegisterBtn(date: store.date))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Happiness 추가하기")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
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

#Preview {
    PieceDetailView(store: Store(initialState: PieceDetail.State(), reducer: { PieceDetail() }))
}
