//
//  DatabaseHelper.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class DatabaseHelper: NSObject {
    class func executeQuery(queryString: String) -> FMResultSet {
        let db: FMDatabase = FMDatabase(path: NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent("Flashcards.db"))
        var resultSet: FMResultSet = FMResultSet()
        db.open()
        resultSet = db.executeQuery(queryString, withParameterDictionary: NSDictionary())
        return resultSet
    }
    
    class func executeUpdate(updateString: String) -> Bool {
        let db: FMDatabase = FMDatabase(path: NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent("Flashcards.db"))
        var success: Bool = false
        db.open()
        success = db.executeUpdate(updateString, withParameterDictionary: NSDictionary())
        return success
    }
}
