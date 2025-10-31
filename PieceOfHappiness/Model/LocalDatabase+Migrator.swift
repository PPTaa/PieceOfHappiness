//
//  LocalDatabase+migrator.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 10/14/25.
//

import Foundation
import GRDB

extension LocalDatabase {
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        migrator.registerMigration("v1") { db in
            try createHappinessAndHashtagTables(db)
        }

        return migrator

    }

    private func createHappinessAndHashtagTables(_ db: GRDB.Database) throws {
        try db.create(table: "Happiness") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("date", .text).notNull()
            table.column("imageData", .text).notNull() // JSON array as string
            table.column("title", .text).notNull()
            table.column("message", .text).notNull()
        }

        try db.create(table: "Hashtag") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("content", .text).notNull().unique()
        }
        
        // Many-to-many relationship table between Happiness and Hashtag
        try db.create(table: "HappinessHashtag") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("happinessId", .integer).notNull()
                .references("Happiness", onDelete: .cascade)
            table.column("hashtagId", .integer).notNull()
                .references("Hashtag", onDelete: .cascade)
            table.uniqueKey(["happinessId", "hashtagId"])
        }
    }
}
