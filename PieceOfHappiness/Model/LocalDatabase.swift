//
//  GRDBManager.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/14/25.
//

import Foundation
import GRDB
import UIKit

struct LocalDatabase {
    private let writer: DatabaseWriter
    init(_ writer: DatabaseWriter) throws {
        self.writer = writer
        try migrator.migrate(writer)
    }
    var reader: DatabaseReader {
        writer
    }
    
    // 데이터베이스 쓰기 작업을 위한 public 메서드
    func write<T>(_ updates: (Database) throws -> T) async throws -> T {
        return try await writer.write(updates)
    }
}
