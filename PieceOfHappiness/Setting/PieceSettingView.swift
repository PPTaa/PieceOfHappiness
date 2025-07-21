//
//  PieceSettingView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import SwiftUI
import ComposableArchitecture

struct PieceSettingView: View {
    @Bindable var store: StoreOf<PieceSetting>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: "설정",
                onLeftButtonTapped: {
                    store.send(.tapBackBtn)
                }
            )
            Spacer()
            Button {
                store.send(.tapFontSettingCell)
            } label: {
                Text("Go to Font Setting")
            }
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    PieceSettingView(store: Store(initialState: PieceSetting.State(), reducer: { PieceSetting() }))
}
