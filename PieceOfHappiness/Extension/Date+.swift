//
//  Date+.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import Foundation

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    // 날짜를 지정된 형식의 문자열로 변환
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // 편의 메서드: yyyy-MM-dd 형식
    var yyyyMMdd: String {
        return formatted("yyyy-MM-dd")
    }
}
