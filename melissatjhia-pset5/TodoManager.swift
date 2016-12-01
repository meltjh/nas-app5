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
    
    func writeTodoList(listTitle: String) {
        do {
            try db!.createList(listTitle: listTitle)
            readTodos()
//            self.TasksTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func deleteTodoList(listId: Int64) {
        do {
            try db!.deleteList(listId: listId)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    func writeTodos(itemTitle: String, listId: Int64) {
        do {
            try db!.createItem(itemTitle: itemTitle, listId: listId)
            readTodos()
            //            self.TasksTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func deleteTodos(itemId: Int64) {
        do {
            try db!.deleteItem(itemId: itemId)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    func updateCompletedTodos(itemId: Int64, completed: Bool) {
        do {
            try db!.update(itemId: itemId, completed: !completed)
            readTodos()
        } catch {
            print(error)
        }
        
    }
}
