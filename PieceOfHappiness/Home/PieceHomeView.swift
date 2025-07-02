//
//  PieceHomeView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 6/26/25.
//

import SwiftUI
import SwiftData
import HorizonCalendar

struct PieceHomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var calendarProxy = CalendarViewProxy()
    
    var body: some View {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1999, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2999, month: 12, day: 31))!
        ScrollView {
            CalendarViewRepresentable(
                calendar: calendar,
                visibleDateRange: startDate...endDate,
                monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()),
                dataDependency: nil,
                proxy: calendarProxy
            )
            .days { day in
                VStack {
                    Image(systemName: "\(day.day).square.fill")
                        .foregroundColor(Color.pink)
                    Text("\(day.day)")
                        .font(.system(size: 18))
                        .foregroundColor(Color(UIColor.label))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(UIColor.systemBlue), lineWidth: 1)
                }
            }
            .monthHeaders { month in
                HStack {
                    Text(verbatim: "\(month.year)년 \(month.month)월")
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.yellow)
                    Image(systemName: "gearshape")
                }
            }
            .dayOfWeekHeaders({ month, weekdayIndex in
                Text(Config.weekdayKeys[weekdayIndex])
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.green)
            })
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .onAppear {
                calendarProxy.scrollToDay(containing: Date(), scrollPosition: .centered, animated: false)
            }
            PieceCardView(title: "dummy text", imageName: "dummy_image", contents: "dummy contents")
            PieceCountView(monthCount: 10, sequenceCount: 5)
            PieceEncourageView()
            
        }
    }
    
}

#Preview {
    PieceHomeView()
        .environment(\.locale, .init(identifier: "ko"))
}
