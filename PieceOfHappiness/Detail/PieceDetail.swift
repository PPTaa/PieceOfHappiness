//
//  PieceDetail.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/24/25.
//
import Foundation
import ComposableArchitecture
import GRDB

@Reducer
struct PieceDetail {
    @ObservableState
    struct State {
        var date: String = ""
        var happiness: Happiness
        var hashTags: [HashTag] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case tapBackBtn
        case onAppear
        
        case loadingHashTag
        case loadedHashTag([HashTag])
        case deleteHappiness
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtn:
                return .run { _ in await self.dismiss() }
                
            case .onAppear:
                return .send(.loadingHashTag)
                
            case .loadingHashTag:
                return .run { [state = state] send in
                    do {
                        let hashTags = try await LocalDatabase.shared.reader.read { db in
                            return try state.happiness.hashtags(in: db)
                        }
                        await send(.loadedHashTag(hashTags))
                    } catch {
                        
                    }
                }
            case let .loadedHashTag(hashTags):
                state.hashTags = hashTags
                return .none
            case .deleteHappiness: return .none
            }
        }
    }
}
