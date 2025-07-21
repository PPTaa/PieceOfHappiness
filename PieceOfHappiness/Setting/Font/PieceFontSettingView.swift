//
//  PieceFontSetting.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/21/25.
//

import SwiftUI
import ComposableArchitecture

struct PieceFontSettingView: View {
    let store: StoreOf<PieceFontSetting>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: "PieceFontSettingView",
                onLeftButtonTapped: {
                    store.send(.tapBackBtn)
                }
            )
            Spacer()
            Text("\(store.fontType) title")
                .appFont(.noteBody(.gaegu(.title)))
            Text("\(store.fontType) body")
                .appFont(.noteBody(.gaegu(.body)))
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    PieceFontSettingView(store: Store(initialState: PieceFontSetting.State(fontType: "pretendard"), reducer: { PieceFontSetting() }))
}
