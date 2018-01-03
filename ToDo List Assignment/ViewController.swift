//
//  ViewController.swift
//  ToDo List Assignment
//
//  Created by YASH SOMPURA on 2018-01-03.
//  Copyright © 2018 YASH SOMPURA. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var todo = ToDo.getMockData()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "ToDo List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < todo.count   {
            let item = todo[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todo.count {
            let item  = todo[indexPath.row]
            item.done = !item.done
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func didTapAddItemButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New To-do item",
            message: "Insert the title of new to-do item:",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {  (_) in
            if let title = alert.textFields?[0].text    {
                self.addNewToDoItem(title: title)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewToDoItem(title: String)  {
        let newIndex = todo.count
        todo.append(ToDo(title: title))
        
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
}

