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
//let endpointString = "https://factchat-cloud.mindlogic.ai/v1/api/openai/chat/completions"
//let payload = OpenAIPayload(
//    model: "gpt-4.1-nano", // gpt-5-nano(약15초), gpt-4.1-nano(약5초), gpt-4o(약6초)
//    messages: [
//        OpenAIMessagePayload(
//            role: "user",
//            content: [
//                OpenAIContentPart(type: "text", text: prompt, image_url: nil),
//                OpenAIContentPart(type: "image_url", text: nil, image_url: OpenAIImageURL(url: dataURL))
//            ]
//        )
//    ],
//    temperature: 1
//)
