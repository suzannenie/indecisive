//
//  Choice.swift
//  Indecisive
//
//  Created by Suzanne Nie on 9/11/20.
//  Copyright © 2020 Suzanne Nie. All rights reserved.
//

import UIKit

class Choice {
    
    //MARK: Properties
    var name: String
    
    
    //MARK: Initialization
    init?(name: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        
    }
    
}
