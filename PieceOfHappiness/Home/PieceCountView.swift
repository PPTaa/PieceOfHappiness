//
//  PieceCountView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import SwiftUI

struct PieceCountView: View {
    let monthCount: Int
    let sequenceCount: Int
    
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
        var showIcon: String {
            switch self {
            case .Month:
                "💡"
            case .Sequence:
                "🔥"
            }
        }
        var showText: String {
            switch self {
            case .Month:
                NSLocalizedString("items", comment: "")
            case .Sequence:
                NSLocalizedString("days", comment: "")
            }
        }
    }
    var type: CountSubViewType = .Month
    let count: Int
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(type.showIcon)
                Text("\(count)")
                Text(type.showText)
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
