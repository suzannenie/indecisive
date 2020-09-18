//
//  ChoiceViewController.swift
//  Indecisive
//
//  Created by Suzanne Nie on 9/11/20.
//  Copyright © 2020 Suzanne Nie. All rights reserved.
//

import UIKit
import os.log

class ChoiceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var optionsText: UITextView!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var choice: Choice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        optionsText.delegate = self
        
        optionsText.text = "Enter options here\r\nPress return between them"
        optionsText.textColor = UIColor.lightGray
        
        // Set up views if editing an existing Meal.
        if let choice = choice {
            navigationItem.title = choice.name
            nameTextField.text = choice.name
            
            os_log("loading choice", log: OSLog.default, type: .debug)
            optionsText.text = choice.options
            optionsText.textColor = UIColor.white
            optionsText.font = UIFont(name: "Courier", size: 20)
        }
        
        // Enable the Save button only if the text field has a valid Choice name.
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
//        let nextTag = textField.tag + 1
//            // Try to find next responder
//        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
//
//            if nextResponder != nil {
//                // Found next responder, so set it
//                nextResponder?.becomeFirstResponder()
//            } else {
//                // Not found, so remove keyboard
//                textField.resignFirstResponder()
//            }
//
//            return false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
        updateSaveButtonState()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
//            // string contains non-whitespace characters
//        }
        if textView.text.isEmpty {
            textView.text = "Enter options here\r\nPress return between them"
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "Arial", size: 12)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter options here\r\nPress return between them" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "Courier", size: 20)
        }
    }

    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddChoiceMode = presentingViewController is UINavigationController
        
        if isPresentingInAddChoiceMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ChoiceViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let options = optionsText.text ?? "Enter options here\r\nPress return between them"
        
        // Set the choice to be passed to ChoiceTableViewController after the unwind segue.
        choice = Choice(name: name, options: options)
    }
    
    
    //MARK: Actions
    
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

