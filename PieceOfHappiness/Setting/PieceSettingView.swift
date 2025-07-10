//
//  PieceSettingView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import SwiftUI
import ComposableArchitecture

struct PieceSettingView: View {
    let store: StoreOf<PieceSetting>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: "설정",
                leftButtonImage: Image(systemName: "arrow.left"),
                onLeftButtonTapped: {
                    print("onLeftButtonTapped")
                    store.send(.tapBackBtn)
                }
            )
            Spacer()
            Text("Setting")
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    PieceSettingView(store: Store(initialState: PieceSetting.State(), reducer: { PieceSetting() }))
}
