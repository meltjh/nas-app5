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
    
    /// The TodoLists are updated with data from the database.
    func readTodos () {
        do {
            try self._todoLists = db!.readAllTodoLists()
        } catch {
            print(error)
        }
    }
    
    /// New TodoList is made and stored in the database.
    func writeTodoList(listTitle: String) {
        do {
            try db!.createList(listTitle: listTitle)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    /// TodoList is removed from the database and the list of TodoLists if updated.
    func deleteTodoList(listId: Int64) {
        do {
            try db!.deleteList(listId: listId)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    /// New TodoList is made and stored in the database.
    func writeTodos(itemTitle: String, listId: Int64) {
        do {
            try db!.createItem(itemTitle: itemTitle, listId: listId)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    /// TodoItem is from the database and the list of TodoLists if updated.
    func deleteTodos(itemId: Int64) {
        do {
            try db!.deleteItem(itemId: itemId)
            readTodos()
        } catch {
            print(error)
        }
    }
    
    /// Completed status of the TodoItem is changed in the database and the list of TodoLists if updated.
    func updateCompletedTodos(itemId: Int64, completed: Bool) {
        do {
            try db!.update(itemId: itemId, completed: !completed)
            readTodos()
        } catch {
            print(error)
        }
        
    }
}
