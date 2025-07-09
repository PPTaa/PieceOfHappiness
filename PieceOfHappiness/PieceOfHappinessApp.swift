//
//  PieceOfHappinessApp.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 6/26/25.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct PieceOfHappinessApp: App {
    var body: some Scene {
        WindowGroup {
            PieceHomeView(store: Store(initialState: PieceHome.State(), reducer: { PieceHome() }))
        }
    }
}
