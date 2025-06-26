//
//  Item.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 6/26/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
