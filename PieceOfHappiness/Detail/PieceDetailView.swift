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
                title: "\(store.date)",
                onLeftButtonTapped: {
                    store.send(.tapBackBtn)
                }
            )
            Spacer()
            Text("Piece Detail View")
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    PieceDetailView(store: Store(initialState: PieceDetail.State(), reducer: { PieceDetail() }))
}
