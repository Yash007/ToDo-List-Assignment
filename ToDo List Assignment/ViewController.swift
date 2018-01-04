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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        do  {
            self.todo = try [ToDo].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found.")
            }
            else
            {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the to-do items!",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistence: \(error)")
            }
        }
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
            
            if(accessory == .checkmark) {
                cell.selectionStyle = UITableViewCellSelectionStyle.default
                cell.isUserInteractionEnabled = false
            }
            else    {
                cell.selectionStyle = UITableViewCellSelectionStyle.blue
                cell.isUserInteractionEnabled = true
            }
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
            title: "Add New Item",
            message: "Enter Item Name:",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {  (_) in
            if let title = alert.textFields?[0].text    {
                self.addNewToDoItem(title: title)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewToDoItem(title: String)  {
        if  title != "" {
            let newIndex = todo.count
            todo.append(ToDo(title: title))
            
            tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < todo.count   {
            todo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        do
        {
            try todo.writeToPersistence()
        }
        catch let error
        {
            NSLog("Error writing to persistence: \(error)")
        }
    }
}

