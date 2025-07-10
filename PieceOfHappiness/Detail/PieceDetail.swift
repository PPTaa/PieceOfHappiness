//
//  PieceDetail.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PieceDetail {
    @ObservableState
    struct State {
        var date: String = ""
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
