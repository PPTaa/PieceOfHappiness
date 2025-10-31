//
//  OpenAI.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/31/25.
//

import Foundation

struct OpenAIPayload: Codable {
    let model: String
    let messages: [OpenAIMessagePayload]
    let temperature: Double
}

struct OpenAIMessagePayload: Codable {
    let role: String
    let content: [OpenAIContentPart]
}

struct OpenAIContentPart: Codable {
    let type: String
    let text: String?
    let image_url: OpenAIImageURL?
}

struct OpenAIImageURL: Codable {
    let url: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}
