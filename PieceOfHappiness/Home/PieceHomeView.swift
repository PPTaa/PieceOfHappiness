//
//  PieceHomeView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 6/26/25.
//

import SwiftUI
import SwiftData
import HorizonCalendar
import ComposableArchitecture

struct PieceHomeView: View {
    @Bindable var store: StoreOf<PieceHome>
    
    @State private var calendarProxy = CalendarViewProxy()
    
    var body: some View {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 1999, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2999, month: 12, day: 31))!
        NavigationStack {
            ScrollView {
                HStack {
                    Text(store.focusedMonth)
                        .appFont(.headlineH1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "gearshape")
                        .onTapGesture {
                            store.send(.tapSettingBtn)
                        }
                }
                Text("\(store.selectedDate)")
                    .appFont(.headlineH1)
                CalendarViewRepresentable(
                    calendar: calendar,
                    visibleDateRange: startDate...endDate,
                    monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()),
                    dataDependency: nil,
                    proxy: calendarProxy
                )
                .monthHeaders { month in
                    HStack {
                        Text(verbatim: "\(month.year)년 \(month.month)월")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.yellow)
                        Image(systemName: "gearshape")
                    }
                }
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
                .dayOfWeekHeaders({ month, weekdayIndex in
                    Text(Config.weekdayKeys[weekdayIndex])
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.green)
                })
                .onDaySelection { day in
                    store.send(.selectDate("\(day.month.year)-\(day.month.month)-\(day.day)"))
                }
                .onDeceleratingEnd({ visibleDayRange in
                    print("\(visibleDayRange)")
                    store.send(.moveMonth("\(visibleDayRange.lowerBound.month.year)-\(visibleDayRange.lowerBound.month.month)"))
                })
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                PieceCardView(title: "dummy text", imageName: "dummy_image", contents: "dummy contents")
                PieceCountView(monthCount: 10, sequenceCount: 5)
                PieceEncourageView()
            }
            .onAppear {
                let today = Date()
                store.send(.moveMonth("\(today.year)-\(today.month)"))
                calendarProxy.scrollToMonth(containing: today, scrollPosition: .centered, animated: false)
            }
            .navigationDestination(
                item: $store.scope(state: \.pieceSetting, action: \.moveToSetting)
            ) { settingStore in
                NavigationStack {
                    PieceSettingView(store: settingStore)
                }
            }
            .navigationDestination(
                item: $store.scope(state: \.pieceDetail, action: \.moveToDetail)
            ) { detailStore in
                PieceDetailView(store: detailStore)
            }
        }
    }
}

#Preview {
    PieceHomeView(store: Store(initialState: PieceHome.State(), reducer: { PieceHome() }))
        .environment(\.locale, .init(identifier: "ko"))
}
