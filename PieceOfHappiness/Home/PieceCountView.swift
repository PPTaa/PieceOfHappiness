//
//  PieceCountView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import SwiftUI

struct PieceCountView: View {
    @State var monthCount = 0
    @State var sequenceCount = 0
    
    var body: some View {
        HStack {
            PieceCountSubview(type: .Month, count: monthCount)
                .frame(maxWidth: .infinity)
            Divider()
            PieceCountSubview(type: .Sequence, count: sequenceCount)
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PieceCountSubview: View {
    enum CountSubViewType {
        case Month
        case Sequence
    }
    @State var type: CountSubViewType = .Month
    @State var count = 0
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                switch type {
                case .Month:
                    Text("💡")
                case .Sequence:
                    Text("🔥")
                }
                Text("\(count)")
                Text("items")
            }
            switch type {
            case .Month:
                Text("count_subview_month_detail")
            case .Sequence:
                Text("count_subview_sequence_detail")
            }
        }
    }
}

#Preview {
    PieceCountView(monthCount: 10, sequenceCount: 4)
}
