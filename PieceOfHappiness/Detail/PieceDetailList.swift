//
//  PieceDetail.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import Foundation
import ComposableArchitecture
import GRDB

@Reducer
struct PieceDetailList {
    @ObservableState
    struct State {
        var date: String = ""
        var happinessList: [Happiness] = []
        var hashTagList: [[HashTag]] = []
        var selectedHappiness: Happiness?
        var hashtags: [HashTag] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case tapBackBtn
        case onAppear
        case loadHappinessData
        case happinessDataLoaded(([Happiness], [[HashTag]]))
        case selectHappiness(Happiness)
        case loadFailed(String)
        case deleteHappiness(Happiness)
        case happinessDeleted(Int64)
        case deleteFailed(String)
        case tapRegisterBtn(date: String)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtn:
                return .run { _ in await self.dismiss() }
                
            case .onAppear:
                return .send(.loadHappinessData)
                
            case .loadHappinessData:
                state.isLoading = true
                state.errorMessage = nil
                return .run { [date = state.date] send in
                    do {
                        let (happinessList, hashTagList) = try await LocalDatabase.shared.reader.read { db in
                            var happinesses: [Happiness]
                            if date.isEmpty {
                                // 날짜가 비어있으면 모든 데이터 조회
                                happinesses = try Happiness.fetchAll(db)
                            } else {
                                // 특정 날짜의 데이터만 조회
                                print("📅 특정 날짜 조회: \(date)")
                                happinesses = try Happiness.filter(Happiness.Columns.date == date).fetchAll(db)
                            }
                            var hashTags: [[HashTag]] = happinesses.compactMap { try? $0.hashtags(in: db) }
                            return (happinesses, hashTags)
                        }
                        await send(.happinessDataLoaded((happinessList, hashTagList)))
                    } catch {
                        await send(.loadFailed("Happiness 데이터 로드 실패: \(error.localizedDescription)"))
                    }
                }
                
            case let .happinessDataLoaded((happinessList, hashTagList)):
                state.isLoading = false
                state.happinessList = happinessList
                state.hashTagList = hashTagList
                print("✅ Happiness 데이터 로드 완료: \(happinessList.count)개")
                return .none
                
            case let .selectHappiness(happiness):
                state.selectedHappiness = happiness
                return .none
                
            case let .loadFailed(message):
                state.isLoading = false
                state.errorMessage = message
                print("❌ \(message)")
                return .none
                
            case let .deleteHappiness(happiness):
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        if let happinessId = happiness.id {
                            try await LocalDatabase.shared.write { db in
                                try happiness.delete(db)
                            }
                            await send(.happinessDeleted(happinessId))
                        }
                    } catch {
                        await send(.deleteFailed("Happiness 삭제 실패: \(error.localizedDescription)"))
                    }
                }
                
            case let .happinessDeleted(happinessId):
                state.isLoading = false
                state.happinessList.removeAll { $0.id == happinessId }
                print("🗑️ Happiness 삭제 완료: \(happinessId)")
                return .none
                
            case let .deleteFailed(message):
                state.isLoading = false
                state.errorMessage = message
                print("❌ \(message)")
                return .none
                
            case .tapRegisterBtn:
                return .none
            }
        }
    }
}
