//
//  GeminiPayload.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/31/25.
//

import Foundation

struct GeminiPayload: Codable {
    let model: String
    let contents: [GeminiContentPayload]
    let temperature: Double?
}

struct GeminiContentPayload: Codable {
    let role: String
    let parts: [GeminiContentPart]
}

struct GeminiContentPart: Codable {
    let text: String?
    let inline_data: GeminiInlineData?
}

struct GeminiInlineData: Codable {
    let mime_type: String
    let data: String
}

struct GeminiResponse: Decodable {
    let candidates: [Candidate]
    
    struct Candidate: Decodable {
        let content: Content
        
        struct Content: Decodable {
            let parts: [Part]
            
            struct Part: Decodable {
                let text: String?
            }
        }
    }
}
//        let endpointString = "https://factchat-cloud.mindlogic.ai/v1/api/google/models/generate-content"
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
