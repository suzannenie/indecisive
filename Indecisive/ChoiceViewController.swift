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
    @IBOutlet weak var decisionMade: UILabel!
    @IBOutlet weak var decideButton: UIButton!
    
    
    /*
     This value is either passed by `ChoiceTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new choice.
     */
    var choice: Choice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // swipe back
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        
        decideButton.layer.borderWidth = 3
        decideButton.layer.borderColor = UIColor.systemGray2.cgColor
        decideButton.layer.cornerRadius = 5
        decideButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        
        nameTextField.delegate = self
        
        optionsText.delegate = self
        optionsText.textContainerInset = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        
        optionsText.text = "Enter options here\r\nPress return between them"
        optionsText.textColor = UIColor.lightGray
        optionsText.font = UIFont(name: "Menlo", size: 14)
        
        decisionMade.font = UIFont(name: "Menlo", size: 28)
        
        // Set up views if editing an existing Choice.
        if let choice = choice {
            navigationItem.title = choice.name
            nameTextField.text = choice.name
            nameTextField.font = UIFont(name: "Menlo", size: 20)
            
            os_log("loading choice", log: OSLog.default, type: .debug)
            optionsText.text = choice.options
            optionsText.textColor = UIColor.white
            optionsText.font = UIFont(name: "Menlo", size: 20)
        }
        
        if optionsText.text.isEmpty {
            optionsText.text = "Enter options here\r\nPress return between them"
            optionsText.textColor = UIColor.lightGray
        }
        
        // Enable the Save button only if the text field has a valid Choice name.
        updateSaveButtonState()
    }

    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
//        textField.resignFirstResponder()
        return true
//        return false
        
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String){
//        // Limit to 9 characters
//        if range.location >= 9 {
//            nameTextField.enablesReturnKeyAutomatically = true
//        } else {
//            nameTextField.enablesReturnKeyAutomatically = false
//        }
//    }
    
    func textViewShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
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
            textView.font = UIFont(name: "Menlo", size: 14)
        }
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateSaveButtonState()
        if textView.text == "Enter options here\r\nPress return between them" {
            textView.text = ""
            textView.textColor = UIColor.white
            textView.font = UIFont(name: "Menlo", size: 20)
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
            
            
            return
        }
        
        let name = nameTextField.text ?? ""
        let options = optionsText.text ?? "Enter options here\r\nPress return between them"
        
        // Set the choice to be passed to ChoiceTableViewController after the unwind segue.
        choice = Choice(name: name, options: options)
    }
    
    
    //MARK: Actions
    @IBAction func decide(_ sender: Any) {
        let str = choice?.options
        let choices = str?.components(separatedBy: "\n")
        
        guard choices?.count ?? 0 > 0 else {
            return
        }

        let randomElement = choices?.randomElement()!
        decisionMade.text = randomElement ?? ""
        
    }
    
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

