//
//  PieceFontSetting.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/21/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct PieceFontSetting {
    @ObservableState
    struct State {
        var fontType: String
    }
    
    enum Action {
        case tapBackBtn
    }
    
    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtn:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
