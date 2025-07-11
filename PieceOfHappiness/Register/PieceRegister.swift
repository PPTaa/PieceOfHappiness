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
