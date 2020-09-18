//
//  Choice.swift
//  Indecisive
//
//  Created by Suzanne Nie on 9/11/20.
//  Copyright © 2020 Suzanne Nie. All rights reserved.
//

import UIKit
import os.log

class Choice: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var options: String
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl: URL = DocumentsDirectory.appendingPathComponent("choices")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let options = "options"
    }
    
    
    //MARK: Initialization
    init?(name: String, options: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.options = options
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(options, forKey: PropertyKey.options)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Choice object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let options = aDecoder.decodeObject(forKey: PropertyKey.options) as? String ?? "Enter options here\r\nPress return between them"
        
        // Must call designated initializer.
        self.init(name: name, options: options)
        
    }
    
}
