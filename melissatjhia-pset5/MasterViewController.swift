//
//  MasterViewController.swift
//  melissatjhia-pset5
//
//  Created by Melissa Tjhia on 28-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet weak var inputListTextField: UITextField!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var savedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        updateWithContentFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Changes to the TodoLists (Adding/Removing)
    
    /// Reads the newest data from the database and the list with the list names is updated.
    func updateWithContentFromDatabase() {
        objects = []
        TodoManager.sharedInstance.readTodos()
        for list in TodoManager.sharedInstance.todoLists {
            objects.insert(list.name, at: 0)
        }
    }
    
    /// Call function when tapping return.
    @IBAction func insertNewList(_ sender: Any) {
        insertNewObject(sender)
    }
    
    /// Insert new TodoList into the database.
    func insertNewObject(_ sender: Any) {
        TodoManager.sharedInstance.writeTodoList(listTitle: inputListTextField.text!)
        updateWithContentFromDatabase()
        self.tableView.reloadData()
        
        inputListTextField.text = ""
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                let todoList = TodoManager.sharedInstance.todoLists.reversed()[indexPath.row]
                controller.todoList = todoList
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        let object = objects[indexPath.row] as! String
        cell.textLabel!.text = object.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listToRemove = TodoManager.sharedInstance.todoLists.reversed()[indexPath.row]
            
            TodoManager.sharedInstance.deleteTodoList(listId: listToRemove.id!)
            updateWithContentFromDatabase()
            self.tableView.reloadData()
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
    // MARK: - State restoration
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.tableView.indexPathForSelectedRow, forKey: "indexPathForSelectedRow")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        savedRow = coder.decodeObject(forKey: "indexPathForSelectedRow") as! IndexPath?
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        guard let savedRow = savedRow else { return }
        self.tableView.selectRow(at: savedRow, animated: false, scrollPosition: UITableViewScrollPosition.middle)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
}

