//
//  ChoiceTableViewCell.swift
//  Indecisive
//
//  Created by Suzanne Nie on 9/11/20.
//  Copyright © 2020 Suzanne Nie. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
