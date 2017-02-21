//
//  ViewController.swift
//  TaskTracker SQLite
//  300907406
//  Created by Serhii Pianykh on 2017-02-16.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//
//  ViewController with all tasks listed

import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks = [Task]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //opening db connection
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open DB")
            return
        }
        
        //creating table if not exists (command and execution)
        let createSQL = "CREATE TABLE IF NOT EXISTS TASKS " + "(ROW INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, DETAILS TEXT, DONE INTEGER, CREATING INTEGER);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open DB")
            return
        }
        
        //inserting initial data (command and execution)
//        let dataSQL = "INSERT INTO TASKS (TITLE, DETAILS, DONE, CREATING) VALUES ('WASH DISHES', '', 0,0);"
//        result = sqlite3_exec(database, dataSQL, nil, nil, &errMsg)
//        if result != SQLITE_OK {
//            sqlite3_close(database)
//            print("Failed to open DB")
//            return
//        }
        
        //fetching data from table and assigning it to array
        let query = "SELECT * FROM TASKS ORDER BY ROW"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let titleData = sqlite3_column_text(statement, 1)
                let detailsData = sqlite3_column_text(statement, 2)
                let done = Int(sqlite3_column_int(statement, 3))
                let title = String.init(cString: titleData!)
                let details = String.init(cString: detailsData!)
                let creating = Int(sqlite3_column_int(statement, 5))
//                print(id)
//                print(done)
//                print(title)
//                print(details)
                tasks.append(Task(id: id,title: title, details: details, done: done, creating: creating))
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: app)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        
        cell.doneTapAction = { (self) in
            cell.updateStatus(task: task)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.saveTapAction = { (self) in
            cell.saveChanges(task: task)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        cell.cancelTapAction = { (self) in
            cell.cancelChanges(task: task)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.configureCell(task: task)
        return cell
    }
    
    //path to storage
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("data.plist").path
        print(url!)
        return url!
    }
    
    //updating table before going to background
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
            let update = "INSERT OR REPLACE INTO TASKS (ROW, TITLE, DETAILS, DONE, CREATING) " + "VALUES (?, ?, ?, ?, ?);"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let title = task.title
                let details = task.details
                let done = task.done
                let changing = task.creating
                sqlite3_bind_int(statement, 1, Int32(i))
                sqlite3_bind_text(statement, 2, title, -1, nil)
                sqlite3_bind_text(statement, 3, details, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(done))
                sqlite3_bind_int(statement, 5, Int32(changing))
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

