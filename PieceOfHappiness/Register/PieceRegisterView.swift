//
//  PieceRegisterView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import SwiftUI
import ComposableArchitecture

struct PieceRegisterView: View {
    let store: StoreOf<PieceRegister>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: "PieceRegisterView",
                onLeftButtonTapped: { store.send(.tapBackBtnWithData("From Register")) }
            )
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("Happiness 더미 데이터 등록")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("저장 버튼을 누르면 더미 Happiness 데이터가\n데이터베이스에 저장됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    store.send(.tapSaveBtnWithData("추가 데이터 - \(Date().timeIntervalSince1970)"))
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
            
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        
    }
}

#Preview {
    PieceRegisterView(store: Store(initialState: PieceRegister.State(), reducer: { PieceRegister() }))
}
