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
        var path = StackState<Path.State>()
    }
    
    enum Action {
        // Other
        case moveMonth(String)
        case selectDate(String)
        case tapRegisterBtn
        case tapSettingBtn
        
        // Navigation
        case path(StackActionOf<Path>)
    }
    @Reducer
    enum Path {
        case moveToDetail(PieceDetail)
        case moveToRegister(PieceRegister)
        // Setting
        case moveToSetting(PieceSetting)
        case moveToFontSetting(PieceFontSetting)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .moveMonth(let monthString):
                state.focusedMonth = monthString
                return .none
                
            // MARK: TO Child
            case .selectDate(let dateString):
                state.selectedDate = dateString
                state.path.append(.moveToDetail(PieceDetail.State(date:dateString)))
                return .none
            case .tapRegisterBtn:
                state.path.append(.moveToRegister(PieceRegister.State()))
                return .none
            case .tapSettingBtn:
                state.path.append(.moveToSetting(PieceSetting.State(text: "from home setting")))
                return .none
                
            // MARK: FROM Child
            case .path(.element(id: _, action: .moveToSetting(.tapBackBtn))):
                return .none
            case .path(.element(id: _, action: .moveToSetting(.tapFontSettingCell))):
                state.path.append(.moveToFontSetting(PieceFontSetting.State(fontType: "TEST")))
                return .none
            case .path(.element(id: _, action: .moveToDetail(.tapBackBtn))):
                return .none
            case .path(.element(id: _, action: .moveToDetail(.tapRegisterBtn))):
                state.path.append(.moveToRegister(PieceRegister.State()))
                return .none
            case .path(.element(id: _, action: .moveToRegister(.tapBackBtnWithData(let dataString)))):
                debugPrint("tapBackBtnWithData : \(dataString)")
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
