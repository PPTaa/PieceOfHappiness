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
        // variable
        var text = "Hello, World!"
        var focusedMonth = ""
        var selectedDate = ""
        // Navigation
        @Presents var pieceDetail: PieceDetail.State?
        @Presents var pieceSetting: PieceSetting.State?
    }
    
    enum Action {
        // Other
        case moveMonth(String)
        case selectDate(String)
        case tapSettingBtn
        // Navigation
        case moveToDetail(PresentationAction<PieceDetail.Action>)
        case moveToSetting(PresentationAction<PieceSetting.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .moveMonth(let monthString):
                state.focusedMonth = monthString
                return .none
            case .selectDate(let dateString):
                state.selectedDate = dateString
                state.pieceDetail = PieceDetail.State(date: dateString)
                return .none
            case .tapSettingBtn:
                state.pieceSetting = PieceSetting.State(text: "frome home setting")
                return .none
                
            case .moveToDetail(.presented(.tapBackBtn)):
                state.pieceDetail = nil
                return .none
            case .moveToDetail(.dismiss):
                return .none
            case .moveToSetting(.presented(.tapBackBtn)):
                state.pieceSetting = nil
                return .none
            case .moveToSetting:
                return .none
            }
        }
        .ifLet(\.$pieceSetting, action: \.moveToSetting) {
            PieceSetting()
        }
    }
}
