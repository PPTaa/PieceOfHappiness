//
//  PieceRegisterView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct PieceRegisterView: View {
    @Bindable var store: StoreOf<PieceRegister>
    @FocusState private var focusedField: Field?
    @State private var selectedItem: PhotosPickerItem?
    private enum Field: Hashable { case title, message }
    
    var body: some View {
        let selectedData = store.selectedData
        
        return VStack {
            BaseHeaderView(
                title: "PieceRegisterView",
                onLeftButtonTapped: { store.send(.tapBackBtnWithData("From Register")) }
            )
            ScrollView {
                VStack(spacing: 20) {
                    // 이미지 첨부 섹션
                    VStack(alignment: .leading, spacing: 8) {
                        Text("이미지")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            if let imageData = selectedData,
                               let selectedImage = UIImage(data: imageData) {
                                
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("이미지 선택")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                    }
                    // 제목 입력 섹션
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목")
                            .font(.headline)
                            .foregroundColor(.primary)
                        TextField("제목 입력", text: $store.title.sending(\.titleChanged))
                            .autocorrectionDisabled()
                    }
                    
                    // 메시지 입력 섹션
                    VStack(alignment: .leading, spacing: 8) {
                        Text("메시지")
                            .font(.headline)
                            .foregroundColor(.primary)
                        TextField("메시지 입력", text: $store.message.sending(\.messageChanged))
                            .autocorrectionDisabled()
                    }
                    
                    // 해시태그 섹션
                    HashTagInputView(store: store)
                    
                    Spacer(minLength: 20)
                    
                    // 저장 버튼
                    Button {
                        store.send(.tapSaveBtnWithData)
                    } label: {
                        Text("Happiness 저장")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    VStack(spacing: 20) {
                        Text("Happiness 더미 데이터 등록")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("저장 버튼을 누르면 더미 Happiness 데이터가\n데이터베이스에 저장됩니다.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            store.send(.tapSaveBtnWithData)
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Happiness 더미 데이터 저장")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("완료") {
                        focusedField = nil
                    }
                }
            }
            .task(id: selectedItem) {
                guard let item = selectedItem else { return }
                if let data = try? await item.loadTransferable(type: Data.self) {
                    store.send(.imageSelected(data))
                }
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        
    }
}

#Preview {
    PieceRegisterView(store: Store(initialState: PieceRegister.State(date: "yyyy-MM-dd"), reducer: { PieceRegister() }))
}

