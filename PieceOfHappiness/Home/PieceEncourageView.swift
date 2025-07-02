//
//  PieceEncourageView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import SwiftUI

struct PieceEncourageView: View {
    var body: some View {
        HStack() {
            Text("💎")
                .font(.system(size: 42))
                .padding(.horizontal, 16)
                .background(Color.white)
            VStack(alignment: .leading) {
                Text("encourage_title")
                Text("encourage_contents")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .background(Color.pink)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

#Preview {
    PieceEncourageView()
}
