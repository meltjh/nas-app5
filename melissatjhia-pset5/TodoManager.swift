//
//  TodoManager.swift
//  melissatjhia-pset5
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    private let db = DatabaseHelper()
    
    private var _todoLists: Array<TodoList> = []
    
    var todoLists: Array<TodoList> {
        get {
            return self._todoLists
        }
    }
    
    private init() {
        if db == nil {
            print("Error")
        }
        readTodos()
    }
    
    func readTodos () {
        do {
            try self._todoLists = db!.readAllTodoLists()
        } catch {
            print(error)
        }
    }
    
    func writeTodos(listTitle: String) {
        do {
            try db!.createList(listTitle: listTitle)
//            self.TasksTableView.reloadData()
        } catch {
            print(error)
        }

    }
    
}