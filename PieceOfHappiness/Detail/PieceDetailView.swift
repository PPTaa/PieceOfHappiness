//
//  PieceDetailView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/24/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct PieceDetailView: View {
    let store: StoreOf<PieceDetail>
    
    var body: some View {
        VStack {
            BaseHeaderView(
                title: "PieceDetailView",
                onLeftButtonTapped: {
                    store.send(.tapBackBtn)
                }
            )
            Text(store.happiness.title)
            Text(store.happiness.message)
            Text(store.hashTags.map{ $0.content }.joined(separator: ", "))
            
            Spacer()
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
    }
}
