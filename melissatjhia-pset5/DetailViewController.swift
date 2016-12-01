//
//  DetailViewController.swift
//  melissatjhia-pset5
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var inputItemTextField: UITextField!
    @IBOutlet weak var todoItemsTableView: UITableView!
    
    var listId: Int64? = nil
    var objects: Array<Any> = []
    
    func configureView() {
        // Update the user interface for the detail item.
        if let list = todoList {
            listId = (list.id)!
            updateObjects()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var todoList: TodoList? {
        didSet {
            print("before")
            self.configureView()
            print("after")
        }
    }
    
    func updateDataViewFromDatabase() {
        TodoManager.sharedInstance.readTodos()
        for todoList in  TodoManager.sharedInstance.todoLists {
            if todoList.id == listId {
                self.todoList = todoList
                updateObjects()
            }
        }
    }
    
    func updateObjects() {
        objects = []
        for todoItem in (todoList?.todos)! {
            objects.append(todoItem.name)
        }
    }
    
    @IBAction func insertNewItem(_ sender: Any) {
        insertNewObject(sender)
    }
    
    func insertNewObject(_ sender: Any) {
        objects.insert(inputItemTextField.text!, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        todoItemsTableView.insertRows(at: [indexPath], with: .automatic)
        
        TodoManager.sharedInstance.writeTodos(itemTitle: inputItemTextField.text!, listId: listId!)
        TodoManager.sharedInstance.readTodos()
        
        inputItemTextField.text = ""
    }
    
    /// Strikes through the task string if it is checked.
    func strikeThrough(cell: UITableViewCell, completed: Bool) {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!)
        if completed {
            attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        }
        else {
            attribute.removeAttribute(NSStrikethroughStyleAttributeName, range: NSMakeRange(0, attribute.length))
        }
        cell.textLabel?.attributedText = attribute
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        let object = objects[indexPath.row] as! String
        cell.textLabel!.text = object.description
        
        strikeThrough(cell: cell, completed: (todoList?.todos.reversed()[indexPath.row].completed)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            print(todoList?.todos[indexPath.row].name)
            let itemToRemove = todoList?.todos.reversed()[indexPath.row]
            
            TodoManager.sharedInstance.deleteTodos(itemId: itemToRemove!.id)
            
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    /// Delete and (un)check buttons that appear when swiping to the right.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let taskToChangeInDB = todoList?.todos.reversed()[indexPath.row]
        
        // The delete button
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // Remove from the database
            TodoManager.sharedInstance.deleteTodos(itemId: taskToChangeInDB!.id)
            
            // Remove from the table view
            self.objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        // Button title depending on checked or not checked.
        var buttonTitle = ""
        if (taskToChangeInDB?.completed)! {
            buttonTitle = "Uncheck"
        }
        else {
            buttonTitle = "Check"
        }
        
        // The (un)check button
        let check = UITableViewRowAction(style: .normal, title: buttonTitle) { (action, indexPath) in
            
            TodoManager.sharedInstance.updateCompletedTodos(itemId: (taskToChangeInDB?.id)!, completed: (taskToChangeInDB?.completed)!)
            
            self.updateDataViewFromDatabase()
            self.todoItemsTableView.reloadData()
        }
        return [delete, check]
    }
}

