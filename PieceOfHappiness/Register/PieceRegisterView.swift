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
            Text("Hello, World!")
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        
    }
}

#Preview {
    PieceRegisterView(store: Store(initialState: PieceRegister.State(), reducer: { PieceRegister() }))
}
