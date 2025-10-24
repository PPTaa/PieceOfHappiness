//
//  PieceHome.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/9/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct PieceHome {
    
    @ObservableState
    struct State {
        // variable
        var text = "Hello, World!"
        var focusedMonth = ""
        var selectedDate = ""
        
        var happinessCount = 0
        
        // Navigation
        var path = StackState<Path.State>()
    }
    
    enum Action {
        // Other
        case moveMonth(String)
        case selectDate(String)
        case updateCurrentMonth(String)
        case updateCurrentMonthHappinessCount(Int)
        case tapRegisterBtn
        case tapSettingBtn
        
        // Navigation
        case path(StackActionOf<Path>)
    }
    @Reducer
    enum Path {
        case moveToDetailList(PieceDetailList)
        case moveToRegister(PieceRegister)
        // Setting
        case moveToSetting(PieceSetting)
        case moveToFontSetting(PieceFontSetting)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .moveMonth(let monthString):
                return .send(.updateCurrentMonth(monthString))
            case .updateCurrentMonth(let monthString):
                state.focusedMonth = monthString
                return .run { send in
                    do {
                        let happinessCount = try await LocalDatabase.shared.reader.read { db in
                            try Happiness.countForMonth(monthString, in: db)
                        }
                        await send(.updateCurrentMonthHappinessCount(happinessCount))
                    } catch {
                    }
                }
            case .updateCurrentMonthHappinessCount(let count):
                state.happinessCount = count
                return .none
            // MARK: - TO Child
            case .selectDate(let dateString):
                state.selectedDate = dateString
                state.path.append(.moveToDetailList(PieceDetailList.State(date:dateString)))
                return .none
            case .tapRegisterBtn:
                state.path.append(.moveToRegister(PieceRegister.State(date: Date().yyyyMMdd)))
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
            case .path(.element(id: _, action: .moveToDetailList(.tapBackBtn))):
                return .none
            case .path(.element(id: _, action: .moveToDetailList(.tapRegisterBtn(let date)))):
                state.path.append(.moveToRegister(PieceRegister.State(date: date)))
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
