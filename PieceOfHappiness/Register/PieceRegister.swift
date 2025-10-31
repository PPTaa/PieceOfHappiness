//
//  PieceRegister.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import Foundation
import ComposableArchitecture
import GRDB
import Vision
import UIKit

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
        case imageSelected(Data)
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
                let string = bcf.string(fromByteCount: Int64(data.count))
                debugPrint("data byteSize: \(data.count)")
                debugPrint("data mb Size: \(string)")
                state.selectedData = data
                return .run { send in
                    try? await classifyImageWithLLM(data: data)
//                    try? await classifyImage(data: data)
                }
            }
        }
    }
}

extension PieceRegister {
    func classifyImage(data: Data) async throws {
        let request = ClassifyImageRequest()
        let results = try await request.perform(on: data)
            .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }

        for classification in results {
            print("raw value \(classification.description)")
            print("identifier \(classification.identifier)")
        }
    }
    
    func classifyImageWithLLM(data: Data) async throws {
        // 1) Prepare image as Base64 (compressed)
        guard let uiImage = UIImage(data: data),
              let jpegData = uiImage.jpegData(compressionQuality: 0.2) else { return }
        let base64 = jpegData.base64EncodedString()
        let dataURL = "data:image/jpeg;base64,\(base64)"

        // 2) Build request to an OpenAI-compatible chat completions endpoint
        let endpointString = "https://factchat-cloud.mindlogic.ai/v1/api/openai/chat/completions"
//        let endpointString = "https://factchat-cloud.mindlogic.ai/v1/api/google/models/generate-content"
        guard let url = URL(string: endpointString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer api-key", forHTTPHeaderField: "Authorization")


        let prompt = "이 이미지를 간단히 설명하고, 최대 5개의 관련 해시태그를 한국어로 추천해줘. 형식: \n설명: ...\n해시태그: #태그1 #태그2 #태그3"

        let payload = OpenAIPayload(
            model: "gpt-5-mini", // gpt-5-nano(약15초), gpt-4.1-nano(약5초), gpt-4o(약6초)
            messages: [
                OpenAIMessagePayload(
                    role: "user",
                    content: [
                        OpenAIContentPart(type: "text", text: prompt, image_url: nil),
                        OpenAIContentPart(type: "image_url", text: nil, image_url: OpenAIImageURL(url: dataURL))
                    ]
                )
            ],
            temperature: 1
        )
//        let payload = GeminiPayload(
//            model: "gemini-2.0-flash", // 2.0flash (약 5초) vs 2.5flash (약 15초)
//            contents: [
//                GeminiContentPayload(
//                    role: "user",
//                    parts: [
//                        GeminiContentPart(text: prompt, inline_data: nil),
//                        GeminiContentPart(text: nil, inline_data: GeminiInlineData(mime_type: "image/jpeg", data: base64))
//                    ]
//                )
//            ],
//            temperature: nil
//        )

        do {
            let encoded = try JSONEncoder().encode(payload)
            request.httpBody = encoded
            let start = Date().timeIntervalSince1970
            debugPrint("start: \(start)")
            let (responseData, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                print("❌ 유효하지 않은 HTTP 응답")
                return
            }

            let end = Date().timeIntervalSince1970
            debugPrint("end: \(end)")
            debugPrint("during time: \(end - start)")
            if (200..<300).contains(http.statusCode) {
                do {
                    let result = try JSONDecoder().decode(OpenAIResponse.self, from: responseData)
                    if let content = result.choices.first?.message.content {
//                    let result = try JSONDecoder().decode(GeminiResponse.self, from: responseData)
//                    if let content = result.candidates.first?.content.parts.first?.text {
                        print("🤖 LLM 분석 결과:\n\(content)")
                    } else {
                        let raw = String(data: responseData, encoding: .utf8) ?? "(binary)"
                        print("⚠️ 예상치 못한 응답 형식: \n\(raw)")
                    }
                } catch {
                    let raw = String(data: responseData, encoding: .utf8) ?? "(binary)"
                    print("⚠️ 디코딩 실패, 원본 응답: \n\(raw)")
                }
            } else {
                let raw = String(data: responseData, encoding: .utf8) ?? "(binary)"
                print("❌ LLM 요청 실패 (status: \(http.statusCode)):\n\(raw)")
            }
        } catch {
            print("❌ LLM 요청 중 오류: \(error)")
            throw error
        }
    }
}
