//
//  PieceRegister.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PieceRegister {
    struct State {

    }
    enum Action {
        case tapBackBtnWithData(String)
    }
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtnWithData:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
