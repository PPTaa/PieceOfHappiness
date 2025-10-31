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

