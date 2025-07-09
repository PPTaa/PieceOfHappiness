//
//  PieceHome.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/9/25.
//

import ComposableArchitecture

@Reducer
struct PieceHome {
    
    @ObservableState
    struct State {
        var text = "Hello, World!"
    }
    
    enum Action {
        case test
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .test:
                return .none
            }
        }
    }
}
