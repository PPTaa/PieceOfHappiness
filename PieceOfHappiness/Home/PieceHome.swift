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
        var consecutiveDaysCount = 0
        
        // Navigation
        var path = StackState<Path.State>()
    }
    
    enum Action {
        // Lifecycle
        case onAppear
        
        // Other
        case moveMonth(String)
        case selectDate(String)
        case updateCurrentMonth(String)
        case updateCurrentMonthHappinessCount(Int)
        case updateConsecutiveCount(Int)
        case tapRegisterBtn
        case tapSettingBtn
        
        // Navigation
        case path(StackActionOf<Path>)
    }
    @Reducer
    enum Path {
        case moveToDetailList(PieceDetailList)
        case moveToRegister(PieceRegister)
        // DetailList
        case moveToDetail(PieceDetail)
        // Setting
        case moveToSetting(PieceSetting)
        case moveToFontSetting(PieceFontSetting)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 현재 월(yyyy-MM) 계산
                let calendar = Calendar.current
                let now = Date()
                let year = calendar.component(.year, from: now)
                let month = calendar.component(.month, from: now)
                let currentMonth = String(format: "%04d-%02d", year, month)
                
                return .merge(
                    .send(.updateCurrentMonth(currentMonth)),
                    .run { send in
                        do {
                            let consecutiveCount = try await LocalDatabase.shared.reader.read { db in
                                try Happiness.currentConsecutiveCount(in: db)
                            }
                            await send(.updateConsecutiveCount(consecutiveCount))
                        } catch {
                            print("❌ 연속 기록 조회 실패: \(error)")
                        }
                    }
                )
                
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
                print("count: ", count)
                state.happinessCount = count
                return .none
                
            case .updateConsecutiveCount(let count):
                print("📊 연속 기록: \(count)일")
                state.consecutiveDaysCount = count
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
            case .path(.element(id: _, action: .moveToDetailList(.selectHappiness(let happiness)))):
                state.path.append(.moveToDetail(PieceDetail.State(happiness: happiness)))
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

