//
//  Image+.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/11/25.
//

import Foundation
import SwiftUI
import UIKit

extension Image {
    static let backButton = Image(systemName: "arrow.left")
    
    init?(data: Data?) {
        guard let data = data else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
    }
}

