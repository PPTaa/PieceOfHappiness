//
//  PieceSetting.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PieceSetting {
    @ObservableState
    struct State {
        var text: String = ""
    }
    enum Action {
        case tapBackBtn
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtn:
                return .none
            }
        }
    }
}
