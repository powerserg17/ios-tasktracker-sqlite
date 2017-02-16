//
//  Task.swift
//  TaskTracker SQLite
//
//  Created by Serhii Pianykh on 2017-02-16.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import Foundation


class Task {
    private var _title: String
    private var _details: String?
    private var _done: Int
    
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
    
    init(title: String) {
        self._title = title
        self._done = 0
    }
    init(title: String, done: Int) {
        self._title = title
        self._done = done
    }
    init(title:String, details: String, done: Int) {
        self._title = title
        self._details = details
        self._done = done
    }
}
