//
//  PieceRegister.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import Foundation
import ComposableArchitecture
import GRDB

@Reducer
struct PieceRegister {
    @ObservableState
    struct State {
        var title: String = ""
        var message: String = ""
        var date: String
        var selectedData: Data? = nil

    }
    enum Action {
        case tapBackBtnWithData(String)
        case tapSaveBtnWithData
        //
        case titleChanged(String)
        case messageChanged(String)
        case imageSelected(Data?)
    }
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapBackBtnWithData:
                return .run { _ in await self.dismiss() }
            case .tapSaveBtnWithData:
                return .run { [state = state] send in
                    do {
                        // 더미 Happiness 데이터 생성
                        var (title, message) = (state.title, state.message)
                        if title.isEmpty { title = "오늘은 정말 행복한 하루였어요! 🌟" }
                        if message.isEmpty { message = "친구들과 함께 맛있는 음식을 먹고, 좋은 영화를 보면서 즐거운 시간을 보냈습니다. 이런 작은 순간들이 모여서 큰 행복이 되는 것 같아요." }
                        var happiness = Happiness(
                            date: state.date,
                            imageData: state.selectedData,
                            title: title,
                            message: message + "\(Date().timeIntervalSince1970)"
                        )

                        // 데이터베이스에 Happiness 저장
                        try await LocalDatabase.shared.write { db in
                            // Happiness 저장 및 ID 받기
                            try happiness.insert(db)
                            
                            // insert 후 마지막 삽입된 rowID 가져오기
                            let lastRowId = db.lastInsertedRowID
                            happiness.id = lastRowId
                            print("💾 insert 후 Happiness ID: \(happiness.id ?? -1)")
                            print("📊 lastInsertedRowID: \(lastRowId)")
                            
                            // ID가 설정된 후 hashtag 추가
                            if let happinessId = happiness.id {
                                print("✅ Happiness ID 확인됨: \(happinessId)")
                                try happiness.addHashtags([
                                    "#행복한하루",
                                    "#친구들과함께",
                                    "#좋은추억",
                                    "#감사",
                                    "#일상의기쁨"
                                ], in: db)
                                
                                print("🏷️ 해시태그 추가 완료!")
                                
                                // 저장된 해시태그 확인
                                let savedHashtags = try happiness.hashtags(in: db)
                                print("✅ 저장된 해시태그: \(savedHashtags.map { $0.content })")
                            } else {
                                print("❌ Happiness ID가 여전히 설정되지 않았습니다.")
                            }
                        }
                        
                        print("✅ Happiness 더미 데이터가 성공적으로 저장되었습니다!")
                        print("📝 제목: \(happiness.title)")
                        print("📅 날짜: \(happiness.date)")
                        print("📸 이미지: \(happiness.imageData)")
                        
                    } catch {
                        print("❌ Happiness 저장 실패: \(error)")
                    }
                }
                
            case let .titleChanged(title):
                state.title = title
                return .none
            case let .messageChanged(message):
                state.message = message
                return .none
            case let .imageSelected(data):
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                let string = bcf.string(fromByteCount: Int64(data!.count))
                debugPrint("data byteSize: \(data?.count)")
                debugPrint("data mb Size: \(string)")
                state.selectedData = data
                return .none
            }
        }
    }
}
