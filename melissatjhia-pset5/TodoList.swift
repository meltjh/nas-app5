//
//  TodoList.swift
//  melissatjhia-pset5
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation

/// The TodoList class stores an id, a name and a list of TodoItems.
class TodoList {
    private var _id: Int64?
    var id: Int64? {
        get {
            return self._id
        }
    }
    
    private var _name: String
    var name: String {
        get {
            return self._name
        }
        set(nameValue) {
            self._name = nameValue
        }
    }
    
    private var _todos: Array<TodoItem>
    var todos: Array<TodoItem> {
        get {
            return self._todos
        }
        set(todosValue) {
            self._todos = todosValue
        }
    }
    
    init(id: Int64, name: String) {
        self._name = name
        self._id = id
        self._todos = []
    }
}
