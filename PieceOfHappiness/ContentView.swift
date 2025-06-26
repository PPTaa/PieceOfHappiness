//
//  ContentView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 6/26/25.
//

import SwiftUI
import SwiftData
import HorizonCalendar

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2025, month: 10, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        
        CalendarViewRepresentable(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()),
            dataDependency: nil
        )
        .days { day in
            VStack {
                Image(systemName: "\(day.day).square.fill")
                    .foregroundColor(Color.pink)
                Text("\(day.day)-1")
                    .font(.system(size: 18))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(UIColor.systemBlue), lineWidth: 1)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color.red)
        Spacer()
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
