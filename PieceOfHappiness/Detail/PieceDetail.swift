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
struct PieceDetail {
    @ObservableState
    struct State {
        var date: String = ""
        var happinessList: [Happiness] = []
        var selectedHappiness: Happiness?
        var hashtags: [HashTag] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Action {
        case tapBackBtn
        case onAppear
        case loadHappinessData
        case happinessDataLoaded([Happiness])
        case selectHappiness(Happiness)
        case loadHashtagsForHappiness(Int64)
        case hashtagsLoaded([HashTag])
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
                        let happinessList = try await LocalDatabase.shared.reader.read { db in
                            if date.isEmpty {
                                // 날짜가 비어있으면 모든 데이터 조회
                                return try Happiness.fetchAll(db)
                            } else {
                                // 특정 날짜의 데이터만 조회
                                print("📅 특정 날짜 조회: \(date)")
                                return try Happiness.filter(Happiness.Columns.date == date).fetchAll(db)
                            }
                        }
                        await send(.happinessDataLoaded(happinessList))
                    } catch {
                        await send(.loadFailed("Happiness 데이터 로드 실패: \(error.localizedDescription)"))
                    }
                }
                
            case let .happinessDataLoaded(happinessList):
                state.isLoading = false
                state.happinessList = happinessList
                print("✅ Happiness 데이터 로드 완료: \(happinessList.count)개")
                for happiness in happinessList {
                    print("📝 제목: \(happiness.title)")
                    print("📅 날짜: \(happiness.date)")
                    print("💬 메시지: \(happiness.message)")
                    print("📸 이미지 경로: \(happiness.imagePath)")
                    print("---")
                }
                return .none
                
            case let .selectHappiness(happiness):
                state.selectedHappiness = happiness
                if let happinessId = happiness.id {
                    return .send(.loadHashtagsForHappiness(happinessId))
                }
                return .none
                
            case let .loadHashtagsForHappiness(happinessId):
                return .run { send in
                    do {
                        print("🔍 해시태그 조회 시작 - Happiness ID: \(happinessId)")
                        
                        let hashtags = try await LocalDatabase.shared.reader.read { db in
                            // 먼저 중간 테이블에 데이터가 있는지 확인
                            let relationCount = try HappinessHashtag
                                .filter(HappinessHashtag.Columns.happinessId == happinessId)
                                .fetchCount(db)
                            print("🔗 HappinessHashtag 관계 개수: \(relationCount)")
                            
                            // 전체 해시태그 개수 확인
                            let totalHashtags = try HashTag.fetchCount(db)
                            print("🏷️ 전체 HashTag 개수: \(totalHashtags)")
                            
                            let sql = """
                                SELECT h.* FROM Hashtag h
                                JOIN HappinessHashtag hh ON h.id = hh.hashtagId
                                WHERE hh.happinessId = ?
                            """
                            print("📝 실행할 SQL: \(sql)")
                            return try HashTag.fetchAll(db, sql: sql, arguments: [happinessId])
                        }
                        
                        print("🎯 조회된 해시태그 개수: \(hashtags.count)")
                        for hashtag in hashtags {
                            print("   - \(hashtag.content) (ID: \(hashtag.id ?? -1))")
                        }
                        
                        await send(.hashtagsLoaded(hashtags))
                    } catch {
                        print("❌ 해시태그 조회 오류: \(error)")
                        await send(.loadFailed("Hashtag 데이터 로드 실패: \(error.localizedDescription)"))
                    }
                }
                
            case let .hashtagsLoaded(hashtags):
                state.hashtags = hashtags
                print("🏷️ 로드된 해시태그: \(hashtags.map { $0.content })")
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
