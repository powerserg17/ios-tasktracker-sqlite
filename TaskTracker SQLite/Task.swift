//
//  Task.swift
//  TaskTracker SQLite
//
//  Created by Serhii Pianykh on 2017-02-16.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import Foundation


class Task {
    private var _id: Int = 0
    private var _title: String
    private var _details: String?
    private var _done: Int
    private var _creating: Int
    
    var id: Int {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var details: String? {
        get {
            return _details
        }
        
        set {
            _details = newValue
        }
    }
    
    var done: Int {
        get {
            return _done
        }
        set {
            _done = newValue
        }
    }
    
    var creating: Int {
        get {
            return _creating
        }
        set {
            _creating = newValue
        }
    }
    
    init(title: String) {
        self._title = title
        self._done = 0
        self._creating = 1
    }
    init(title: String, done: Int) {
        self._title = title
        self._done = done
        self._creating = 0
    }
    init(id: Int,title:String, details: String, done: Int, creating: Int) {
        self._id = id
        self._title = title
        self._details = details
        self._done = done
        self._creating = creating
    }
}
