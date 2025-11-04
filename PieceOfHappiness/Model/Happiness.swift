//
//  File.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/14/25.
//

import Foundation
import GRDB

struct Happiness {
    var id: Int64?
    var date: String // yyyy-MM-dd
    var imageData: Data? // JSON으로 저장될 배열
    var title: String
    var message: String
    
    init(date: String, imageData: Data?, title: String, message: String) {
        self.date = date
        self.imageData = imageData
        self.title = title
        self.message = message
    }
}

// GRDB Record conformance
extension Happiness: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns
    static let databaseTableName = "Happiness"
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let date = Column(CodingKeys.date)
        static let imageData = Column(CodingKeys.imageData)
        static let title = Column(CodingKeys.title)
        static let message = Column(CodingKeys.message)
    }
    
    // Encode/decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int64.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        imageData = try container.decode(Data.self, forKey: .imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(message, forKey: .message)
        try container.encode(imageData, forKey: .imageData)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, date, imageData, title, message
    }
    
    // GRDB persistence
    mutating func didInsert(with rowID: Int64, for column: String?) {
        print("🆔 didInsert 호출됨 - rowID: \(rowID), column: \(column ?? "nil")")
        id = rowID
        print("🆔 didInsert 완료 - happiness.id: \(id ?? -1)")
    }
    
    // Hashtag 관련 편의 메서드들
    func hashtags(in db: Database) throws -> [HashTag] {
        guard let happinessId = id else { return [] }
        
        let sql = """
            SELECT h.* FROM Hashtag h
            JOIN HappinessHashtag hh ON h.id = hh.hashtagId
            WHERE hh.happinessId = ?
        """
        
        return try HashTag.fetchAll(db, sql: sql, arguments: [happinessId])
    }
    
    func addHashtags(_ hashtags: [HashTag], in db: Database) throws {
        let hashTagStrings: [String] = hashtags.map { $0.content }
        try self.addHashtags(hashTagStrings, in: db)
    }
    
    func addHashtags(_ hashtags: [String], in db: Database) throws {
        guard let happinessId = id else {
            print("❌ addHashtags: Happiness ID가 nil입니다!")
            return
        }
        
        print("🔄 addHashtags 시작 - Happiness ID: \(happinessId), 추가할 해시태그: \(hashtags)")
        
        for hashtagContent in hashtags {
            print("🏷️ 처리 중인 해시태그: \(hashtagContent)")
            
            // 기존 hashtag가 있는지 확인
            var hashtag = try HashTag.filter(HashTag.Columns.content == hashtagContent).fetchOne(db)
            
            // 없으면 새로 생성
            if hashtag == nil {
                print("   ➕ 새 해시태그 생성: \(hashtagContent)")
                hashtag = HashTag(content: hashtagContent)
                try hashtag!.insert(db)
                
                // HashTag ID 설정
                let hashtagRowId = db.lastInsertedRowID
                hashtag!.id = hashtagRowId
                print("   ✅ 해시태그 저장 완료 - ID: \(hashtag!.id ?? -1)")
            } else {
                print("   ♻️ 기존 해시태그 사용 - ID: \(hashtag!.id ?? -1)")
            }
            
            guard let hashtagId = hashtag!.id else {
                print("   ❌ 해시태그 ID가 nil입니다!")
                continue
            }
            
            // 이미 연결되어 있는지 확인
            let exists = try HappinessHashtag
                .filter(HappinessHashtag.Columns.happinessId == happinessId &&
                       HappinessHashtag.Columns.hashtagId == hashtagId)
                .fetchOne(db) != nil
            
            // 연결되어 있지 않으면 새로 생성
            if !exists {
                print("   🔗 관계 생성 중: happinessId=\(happinessId), hashtagId=\(hashtagId)")
                var happinessHashtag = HappinessHashtag(happinessId: happinessId, hashtagId: hashtagId)
                try happinessHashtag.insert(db)
                
                // HappinessHashtag ID 설정
                let relationRowId = db.lastInsertedRowID
                happinessHashtag.id = relationRowId
                print("   ✅ 관계 생성 완료 - 관계 ID: \(happinessHashtag.id ?? -1)")
            } else {
                print("   ↔️ 이미 연결되어 있음")
            }
        }
        
        print("🏁 addHashtags 완료")
    }
    
    func removeHashtag(_ hashtagContent: String, in db: Database) throws {
        guard let happinessId = id else { return }
        
        let sql = """
            DELETE FROM HappinessHashtag 
            WHERE happinessId = ? AND hashtagId IN (
                SELECT id FROM Hashtag WHERE content = ?
            )
        """
        
        try db.execute(sql: sql, arguments: [happinessId, hashtagContent])
    }
}

extension Happiness {
    static func countForMonth(_ yearMonth: String, in db: Database) throws -> Int {
        let sql = """
            SELECT COUNT(*) FROM Happiness
            WHERE date LIKE ?
        """
        
        return try Int.fetchOne(db, sql: sql, arguments: ["\(yearMonth)%"]) ?? 0
    }
    
    // 특정 달의 모든 Happiness 조회
    static func fetchForMonth(_ yearMonth: String, in db: Database) throws -> [Happiness] {
        let sql = """
            SELECT * FROM Happiness
            WHERE date LIKE ?
            ORDER BY date DESC
        """
        
        return try Happiness.fetchAll(db, sql: sql, arguments: ["\(yearMonth)%"])
    }
    
    // 특정 날짜부터 과거로 연속된 Happiness 개수 계산
    static func consecutiveCount(from dateString: String, in db: Database) throws -> Int {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard var currentDate = dateFormatter.date(from: dateString) else {
            print("❌ 잘못된 날짜 형식: \(dateString)")
            return 0
        }
        
        var consecutiveCount = 0
        
        // 해당 날짜부터 과거로 거슬러 올라가며 연속 확인
        while true {
            let checkDateString = dateFormatter.string(from: currentDate)
            
            // 해당 날짜에 Happiness가 있는지 확인
            let count = try Happiness
                .filter(Happiness.Columns.date == checkDateString)
                .fetchCount(db)
            
            if count > 0 {
                consecutiveCount += 1
                // 하루 전으로 이동
                guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                    break
                }
                currentDate = previousDate
            } else {
                break
            }
        }
        
        print("📊 연속 기록: \(dateString)부터 \(consecutiveCount)일")
        return consecutiveCount
    }
    
    // 오늘부터 과거로 연속된 Happiness 개수 계산
    static func currentConsecutiveCount(in db: Database) throws -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        return try consecutiveCount(from: todayString, in: db)
    }
}
