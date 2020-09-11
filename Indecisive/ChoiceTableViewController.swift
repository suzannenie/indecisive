//
//  ChoiceTableViewController.swift
//  Indecisive
//
//  Created by Suzanne Nie on 9/11/20.
//  Copyright © 2020 Suzanne Nie. All rights reserved.
//

import UIKit
import os.log

class ChoiceTableViewController: UITableViewController {
    
    //MARK: Properties
    var choices = [Choice]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedChoices = loadChoices() {
            choices += savedChoices
        }
        else {
            // Load the sample data.
            loadSampleChoices()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ChoiceTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChoiceTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChoiceTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let choice = choices[indexPath.row]
        
        cell.nameLabel.text = choice.name
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            choices.remove(at: indexPath.row)
            saveChoices()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddChoice":
            os_log("Adding a new choice.", log: OSLog.default, type: .debug)
            
        case "ShowChoiceDetail":
            guard let choiceDetailViewController = segue.destination as? ChoiceViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedChoiceCell = sender as? ChoiceTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedChoiceCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedChoice = choices[indexPath.row]
            choiceDetailViewController.choice = selectedChoice
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    
    //MARK: Actions
    
    @IBAction func unwindToChoiceList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ChoiceViewController, let choice = sourceViewController.choice {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                choices[selectedIndexPath.row] = choice
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new choice.
                let newIndexPath = IndexPath(row: choices.count, section: 0)
                
                choices.append(choice)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveChoices()
        }
    }
    
    
    //MARK: Private Methods
     
    private func loadSampleChoices() {
    
        guard let choice1 = Choice(name: "choice1") else {
            fatalError("Unable to instantiate choice1")
        }
        guard let choice2 = Choice(name: "choice2") else {
            fatalError("Unable to instantiate choice2")
        }
        guard let choice3 = Choice(name: "choice3") else {
            fatalError("Unable to instantiate choice3")
        }
        
        choices += [choice1, choice2, choice3]
    }
    
    private func saveChoices() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(choices, toFile: Choice.ArchiveUrl.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: choices, requiringSecureCoding: true)
//            try data.write(to: Choice.ArchiveUrl)
//
//        } catch {
//
//            os_log("Failed to save ...", log: OSLog.default, type: .error)
//        }
    }
    
    private func loadChoices() -> [Choice]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Choice.ArchiveUrl.path) as? [Choice]
//        if let archivedData = try? Data(contentsOf: Choice.ArchiveUrl),
//            let myObject = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [Choice] {
//                return myObject
//        }
//        os_log("Failed to LOAD ...", log: OSLog.default, type: .error)
//        return nil
    }
}
