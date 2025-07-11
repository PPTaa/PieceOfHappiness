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
        @Presents var pieceRegister: PieceRegister.State?
        @Presents var pieceSetting: PieceSetting.State?
    }
    
    enum Action {
        // Other
        case moveMonth(String)
        case selectDate(String)
        case tapRegisterBtn
        case tapSettingBtn
        // Navigation
        case moveToDetail(PresentationAction<PieceDetail.Action>)
        case moveToRegister(PresentationAction<PieceRegister.Action>)
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
            case .tapRegisterBtn:
                state.pieceRegister = PieceRegister.State()
                return .none
            case .tapSettingBtn:
                state.pieceSetting = PieceSetting.State(text: "frome home setting")
                return .none
                
                // MARK: FROM Child
            case .moveToDetail(.dismiss),
                    .moveToDetail(.presented(.tapBackBtn)):
                state.pieceDetail = nil
                return .none
            case .moveToRegister(.dismiss),
                    .moveToRegister(.presented(.tapBackBtn)):
                state.pieceRegister = nil
                return .none
            case .moveToSetting(.dismiss),
                    .moveToSetting(.presented(.tapBackBtn)):
                state.pieceSetting = nil
                return .none
            }
        }
        .ifLet(\.$pieceDetail, action: \.moveToDetail) {
            PieceDetail()
        }
        .ifLet(\.$pieceRegister, action: \.moveToRegister) {
            PieceRegister()
        }
        .ifLet(\.$pieceSetting, action: \.moveToSetting) {
            PieceSetting()
        }
    }
}
