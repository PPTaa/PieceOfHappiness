//
//  LocalDatabase+Persistent.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/14/25.
//

import Foundation
import GRDB
import UIKit

extension LocalDatabase {
    
    /// 앱 전체에서 공유하는 데이터베이스 인스턴스
    static let shared = makeShared()
    
    /// 공유 데이터베이스 인스턴스 생성
    static func makeShared() -> LocalDatabase {
        do {
            // Documents 디렉토리에 데이터베이스 파일 생성
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
            let dbPath = documentsPath.appendingPathComponent("PieceOfHappiness.sqlite")
            
            // 외래키 제약조건 활성화
            var config = Configuration()
            config.foreignKeysEnabled = true
            
            let writer = try DatabaseQueue(path: dbPath.path, configuration: config)
            
            // LocalDatabase 인스턴스 생성 (이때 마이그레이션 실행됨)
            let database = try LocalDatabase(writer)
            
            return database
        } catch {
            fatalError("Database initialization failed: \(error)")
        }
    }
}
