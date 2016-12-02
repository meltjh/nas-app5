//
//  DatabaseHelper.swift
//  melissatjhia-pset4
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    private let todo_item = Table("todo_item")
    private let todo_list = Table("todo_list")
    private let itemId = Expression<Int64>("id")
    private let listId = Expression<Int64>("list_id")
    private let itemName = Expression<String?>("item_name")
    private let completed = Expression<Bool>("completed")
    private let listName = Expression<String>("list_name")
    private var db: Connection?
    
    init? () {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Database setup.
    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
    }
    
    /// Creates the table with columns for the id, task and whether the task is checked off.
    private func createTable() throws {
        do {
            try db!.run(todo_item.create(ifNotExists: true) {
                t in
                t.column(itemId, primaryKey: .autoincrement)
                t.column(listId)
                t.column(itemName)
                t.column(completed)
            })
            
            try db!.run(todo_list.create(ifNotExists: true) {
                t in
                t.column(listId, primaryKey: .autoincrement)
                t.column(listName)
            })
            
        } catch {
            throw error
        }
    }
    
    /// Creates a TodoItem entry.
    func createItem(itemTitle: String, listId: Int64) throws {
        let insert = todo_item.insert(self.itemName <- itemTitle, self.completed <- false, self.listId <- listId)
        
        do {
            _ = try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    /// Creates a TodoList entry.
    func createList(listTitle: String) throws {
        let insert = todo_list.insert(self.listName <- listTitle)
        
        do {
            _ = try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    
    /// Reads all the items that belong to a list
    func readTodoList(listId: Int64, listName: String) throws -> TodoList {
        let todoList = TodoList(id: listId, name: listName)
        
        do {
            for item in try db!.prepare(todo_item.filter(self.listId == listId)) {
                let todoItem = TodoItem(name: item[itemName]!, id: item[itemId])
                todoItem.completed = item[completed]
                todoList.todos.append(todoItem)
            }
        } catch {
            throw error
        }
        return todoList
    }
    
    /// Makes a list that consists of all the TodoLists.
    func readAllTodoLists() throws -> Array<TodoList> {
        var allTodoLists: Array<TodoList> = []
        
        do {
            for list in try db!.prepare(todo_list) {
                allTodoLists.append(try readTodoList(listId: list[listId], listName: list[listName]))
            }
        } catch {
            throw error
        }
        return allTodoLists
    }
    
    /// Updates the check status of a TodoItem in the database.
    func update(itemId: Int64, completed: Bool) throws {
        do {
            _ = try db!.run(todo_item.filter(itemId == self.itemId).update(self.completed <- completed))
        } catch {
            throw error
        }
    }
    
    /// Deletes the entry of a TodoItem from the database.
    func deleteItem(itemId: Int64) throws {
        do {
            _ = try db!.run(todo_item.filter(itemId == self.itemId).delete())
        } catch {
            throw error
        }
    }
    
    /// Deletes the entry of a TodoList from the database and the TodoItems that belong to it.
    func deleteList(listId: Int64) throws {
        do {
            _ = try db!.run(todo_list.filter(listId == self.listId).delete())
            _ = try db!.run(todo_item.filter(listId == self.listId).delete())
        } catch {
            throw error
        }
    }
}
