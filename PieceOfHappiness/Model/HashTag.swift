//
//  Hash.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/14/25.
//

import Foundation
import GRDB

struct HashTag {
    var id: Int64?
    let content: String
    
    init(content: String) {
        self.content = content
    }
}

// GRDB Record conformance
extension HashTag: Codable, FetchableRecord, MutablePersistableRecord {
    static let databaseTableName = "Hashtag"
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let content = Column(CodingKeys.content)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, content
    }
    
    // GRDB persistence
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // Happiness 조회 관련 편의 메서드들
    func happiness(in db: Database) throws -> [Happiness] {
        guard let hashtagId = id else { return [] }
        
        let sql = """
            SELECT h.* FROM Happiness h
            JOIN HappinessHashtag hh ON h.id = hh.happinessId
            WHERE hh.hashtagId = ?
        """
        
        return try Happiness.fetchAll(db, sql: sql, arguments: [hashtagId])
    }
    
    // 특정 해시태그 내용으로 연결된 모든 Happiness 조회 (정적 메서드)
    static func happiness(forHashtagContent content: String, in db: Database) throws -> [Happiness] {
        let sql = """
            SELECT h.* FROM Happiness h
            JOIN HappinessHashtag hh ON h.id = hh.happinessId
            JOIN Hashtag ht ON ht.id = hh.hashtagId
            WHERE ht.content = ?
        """
        
        return try Happiness.fetchAll(db, sql: sql, arguments: [content])
    }
    
    // 해시태그의 사용 횟수 조회
    func usageCount(in db: Database) throws -> Int {
        guard let hashtagId = id else { return 0 }
        
        return try HappinessHashtag
            .filter(HappinessHashtag.Columns.hashtagId == hashtagId)
            .fetchCount(db)
    }
    
    // 가장 많이 사용된 해시태그들 조회 (정적 메서드)
    static func mostUsedHashtags(limit: Int = 10, in db: Database) throws -> [(HashTag, Int)] {
        let sql = """
            SELECT ht.*, COUNT(hh.hashtagId) as usage_count
            FROM Hashtag ht
            LEFT JOIN HappinessHashtag hh ON ht.id = hh.hashtagId
            GROUP BY ht.id
            ORDER BY usage_count DESC
            LIMIT ?
        """
        
        let rows = try Row.fetchAll(db, sql: sql, arguments: [limit])
        return rows.compactMap { row in
            guard let hashtag = try? HashTag(row: row) else { return nil }
            let count = row["usage_count"] as? Int ?? 0
            return (hashtag, count)
        }
    }
}

// HappinessHashtag 중간 테이블을 위한 구조체
struct HappinessHashtag {
    var id: Int64?
    let happinessId: Int64
    let hashtagId: Int64
    
    init(happinessId: Int64, hashtagId: Int64) {
        self.happinessId = happinessId
        self.hashtagId = hashtagId
    }
}

extension HappinessHashtag: Codable, FetchableRecord, MutablePersistableRecord {
    static let databaseTableName = "HappinessHashtag"
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let happinessId = Column(CodingKeys.happinessId)
        static let hashtagId = Column(CodingKeys.hashtagId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, happinessId, hashtagId
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
