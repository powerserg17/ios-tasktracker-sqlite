//
//  ViewController.swift
//  TaskTracker SQLite
//
//  Created by Serhii Pianykh on 2017-02-16.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open DB")
            return
        }
        
        let createSQL = "CREATE TABLE IF NOT EXISTS TASKS " + "(ROW INTEGER PRIMARY KEY, TITLE TEXT, DETAILS TEXT, DONE INTEGER DEFAULT 0);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open DB")
            return
        }
        
        let query = "SELECT * FROM TASKS ORDER BY ROW"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let titleData = sqlite3_column_text(statement, 1)
                let detailsData = sqlite3_column_text(statement, 2)
                let done = Int(sqlite3_column_int(statement, 3))
                let title = String.init(cString: titleData!)
                let details = String.init(cString: detailsData!)
                tasks.append(Task(title: title, details: details, done: done))
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: app)

    }
    
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open DB")
            return
        }
        
        for i in 0..<tasks.count {
            let task = tasks[i]
            let update = "INSERT OR REPLACE INTO TASKS (ROW, TITLE, DETAILS, DONE) " + "VALUES (?, ?, ?, ?);"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let title = task.title
                let details = task.details
                let done = task.done
                sqlite3_bind_int(statement, 1, Int32(i))
                sqlite3_bind_text(statement, 2, title, -1, nil)
                sqlite3_bind_text(statement, 3, details, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(done))
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating table")
                sqlite3_close(database)
                return
            }
            
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
    }

}

